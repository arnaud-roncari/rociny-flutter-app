import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_legal_informations/complete_company_legal_informations_bloc.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/legal_documents.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/stripe.dart';

import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteCompanyLegalInformationsPage extends StatefulWidget {
  const CompleteCompanyLegalInformationsPage({super.key});

  @override
  State<CompleteCompanyLegalInformationsPage> createState() => _CompleteCompanyLegalInformationsPageState();
}

class _CompleteCompanyLegalInformationsPageState extends State<CompleteCompanyLegalInformationsPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteCompanyLegalInformationsBloc, CompleteCompanyLegalInformationsState>(
        listener: (context, state) {
          if (state is UpdateDocumentFailed || state is CreateSetupIntentFailed) {
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
                        context.go("/company/home");
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
                    children: const [LegalDocuments(), Stripe()],
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
                      context.go("/company/home");
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
