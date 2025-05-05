import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_legal_informations/complete_influencer_legal_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/legal_documents.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/stripe.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteInfluencerLegalInformationsPage extends StatefulWidget {
  const CompleteInfluencerLegalInformationsPage({super.key});

  @override
  State<CompleteInfluencerLegalInformationsPage> createState() => _CompleteInfluencerLegalInformationsPageState();
}

class _CompleteInfluencerLegalInformationsPageState extends State<CompleteInfluencerLegalInformationsPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteInfluencerLegalInformationsBloc, CompleteInfluencerLegalInformationsState>(
        listener: (context, state) {
          if (state is UpdateDocumentFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is UpdateDocumentSuccess) {
            Alert.showSuccess(context, "changes_saved".translate());
          }
        },
        builder: (context, state) {
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
                    children: const [
                      LegalDocuments(),
                      Stripe(),
                    ],
                  ),
                ),
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
