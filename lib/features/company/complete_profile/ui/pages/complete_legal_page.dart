import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/company/complete_profile/ui/widgets/update_billing_address_form.dart';
import 'package:rociny/features/company/complete_profile/ui/widgets/update_stripe_payment_method_form.dart';
import 'package:rociny/features/company/complete_profile/ui/widgets/update_trade_name_form.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/update_vat_form.dart';

import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteLegalPage extends StatefulWidget {
  const CompleteLegalPage({super.key});

  @override
  State<CompleteLegalPage> createState() => _CompleteLegalPageState();
}

class _CompleteLegalPageState extends State<CompleteLegalPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is UpdateDocumentFailed ||
              state is CreateSetupIntentFailed ||
              state is UpdateBillingAddressFailed ||
              state is UpdateTradeNameFailed ||
              state is UpdateVATNumberFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is ProfileUpdated) {
            Alert.showSuccess(context, "changes_saved".translate());
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
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 4",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      // UpdateLegalDocumentsForm(
                      //   documents: {
                      //     LegalDocumentType.debug: bloc.debugStatus,
                      //   },
                      //   onUpdated: (type) {
                      //     bloc.add(UpdateDocument(type: type));
                      //   },
                      // ),
                      UpdateStripePaymentMethodForm(onUpdated: () {
                        bloc.add(CreateSetupIntent());
                      }),
                      UpdateTradeNameForm(
                        initialValue: bloc.company.tradeName,
                        onUpdated: (tradeName) {
                          bloc.add(UpdateTradeName(tradeName: tradeName));
                        },
                      ),
                      UpdateBillingAddressForm(
                        city: bloc.company.city,
                        street: bloc.company.street,
                        postalCode: bloc.company.postalCode,
                        onUpdated: (city, street, postalCode) {
                          bloc.add(UpdateBillingAddress(city: city, street: street, postalCode: postalCode));
                        },
                      ),
                      UpdateVATForm(
                        initialValue: bloc.company.vatNumber,
                        onUpdated: (vatNumber) {
                          bloc.add(UpdateVATNumber(vatNumber: vatNumber));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding20),
                Button(
                  title: index == 3 ? "finish".translate() : "next_step".translate(),
                  onPressed: () {
                    if (index != 3) {
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
