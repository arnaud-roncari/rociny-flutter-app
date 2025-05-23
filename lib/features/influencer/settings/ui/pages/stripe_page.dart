// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class StripePage extends StatefulWidget {
  const StripePage({super.key});

  @override
  State<StripePage> createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) async {
            final bloc = context.read<SettingsBloc>();

            if (state is GetStripeAccountLinkSuccess) {
              var bool =
                  await context.push("/influencer/settings/company/stripe/webview", extra: bloc.stripeAccountUrl!);
              if (bool != null && bool == true) {
                bloc.add(SetStripeAccountStatus());
                Alert.showSuccess(context, "Modifications sauvegardées.");
              } else {
                Alert.showError(context, "Votre compte Stripe est incomplet.");
              }
            }

            if (state is GetStripeLoginLinkSuccess) {
              await context.push("/influencer/settings/company/stripe/webview", extra: bloc.stripeLoginUrl!);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgButton(
                      path: "assets/svg/left_arrow.svg",
                      color: kBlack,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                    Text(
                      "Stripe",
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Text(
                  "Stripe",
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding10),
                Text(
                  getText(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding20),
                ChipButton(
                  label: getChipText(),
                  onTap: () async {
                    SettingsBloc bloc = context.read<SettingsBloc>();
                    if (state is GetStripeAccountLinkLoading || state is GetStripeLoginLinkLoading) {
                      return;
                    }

                    if (bloc.hasCompletedStripe) {
                      bloc.add(GetStripeLoginLink());
                    } else {
                      bloc.add(GetStripeAccountLink());
                    }
                  },
                ),
                const Spacer(),
              ],
            );
          },
        ),
      )),
    );
  }

  String getText() {
    SettingsBloc bloc = context.read<SettingsBloc>();

    if (bloc.hasCompletedStripe) {
      return "stripe_payment_info_completed".translate();
    }

    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    SettingsBloc bloc = context.read<SettingsBloc>();

    if (bloc.hasCompletedStripe) {
      return "my_account".translate();
    }

    return "start".translate();
  }
}
