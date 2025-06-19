import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/ui/widgets/update_legal_documents_form.dart';
import 'package:rociny/features/influencer/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/stripe_form.dart';
import 'package:rociny/shared/widgets/stripe_modal.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteLegalPage extends StatefulWidget {
  const CompleteLegalPage({super.key});

  @override
  State<CompleteLegalPage> createState() => _CompleteLegaltate();
}

class _CompleteLegaltate extends State<CompleteLegalPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) async {
          final bloc = context.read<CompleteProfileBloc>();

          if (state is UpdateDocumentFailed ||
              state is GetStripeCompletionStatusFailed ||
              state is UpdateStripeFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is ProfileUpdated) {
            Alert.showSuccess(context, "changes_saved".translate());
          }

          if (state is StripeUrlFetched) {
            String url = state.url;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: false,
              backgroundColor: kWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              builder: (context) {
                return StripeModal(url: url);
              },
            );

            bloc.add(GetStripeCompletionStatus());
          }
        },
        builder: (context, state) {
          final bloc = context.read<CompleteProfileBloc>();
          return Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              children: [
                Row(
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
                        }
                      },
                    ),
                    const Spacer(),
                    Text("  ${"profile".translate()}", style: kTitle1Bold),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.go("/influencer/home");
                      },
                      child: Text(
                        "ignore".translate(),
                        style: kBodyBold.copyWith(color: kGrey300),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 2",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      UpdateLegalDocumentsForm(
                        documents: {
                          LegalDocumentType.debug: bloc.debugStatus,
                        },
                        onUpdated: (type) {
                          bloc.add(UpdateDocument(type: type));
                        },
                      ),
                      StripeForm(
                        isStripeCompleted: bloc.isStripeCompleted,
                        onPressed: (isStripeCompleted) {
                          if (isStripeCompleted) {
                            bloc.add(GetStripeAccount());
                          } else {
                            bloc.add(CreateStripeAccount());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding20),
                Button(
                  title: index == 1 ? "finish".translate() : "next_step".translate(),
                  onPressed: () {
                    if (index != 1) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      context.go("/influencer/home");
                    }
                  },
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
