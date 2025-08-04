import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/billing_form.dart';
import 'package:rociny/features/company/search/ui/widgets/file_form.dart';
import 'package:rociny/features/company/search/ui/widgets/product_placement_form.dart';
import 'package:rociny/features/company/search/ui/widgets/title_form.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CreateCollaborationPage extends StatefulWidget {
  const CreateCollaborationPage({super.key});

  @override
  State<CreateCollaborationPage> createState() => _CreateCollaborationPageState();
}

class _CreateCollaborationPageState extends State<CreateCollaborationPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<PreviewBloc, PreviewState>(
          listener: (context, state) {
            if (state is StepUpdated) {
              if (state.index == 4) {
                context.push("/company/home/preview/create/collaboration/preview");
                return;
              }

              setState(() {
                index = state.index;
              });
              pageController.jumpToPage(index);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: kPadding20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Row(
                    children: [
                      SvgButton(
                        path: 'assets/svg/left_arrow.svg',
                        color: kBlack,
                        onPressed: () {
                          if (index != 0) {
                            setState(() {
                              index -= 1;
                            });
                            pageController.jumpToPage(index);
                          } else {
                            context.pop();
                          }
                        },
                      ),
                      const Spacer(),
                      Text("propose_collaboration".translate(), style: kTitle1Bold),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 4",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: const [
                      BillingForm(),
                      TitleForm(),
                      ProductPlacementForm(),
                      FileForm(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
