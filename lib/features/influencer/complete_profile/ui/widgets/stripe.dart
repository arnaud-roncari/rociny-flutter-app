// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_profile/bloc/complete_influencer_legal_informations/complete_influencer_legal_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Stripe extends StatefulWidget {
  const Stripe({super.key});

  @override
  State<Stripe> createState() => _StripeState();
}

class _StripeState extends State<Stripe> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompleteInfluencerLegalInformationsBloc, CompleteInfluencerLegalInformationsState>(
      listener: (context, state) async {
        CompleteInfluencerLegalInformationsBloc bloc = context.read<CompleteInfluencerLegalInformationsBloc>();
        if (state is GetStripeAccountLinkSuccess) {
          var bool = await context.push("/influencer/complete_register/stripe/webview", extra: bloc.stripeAccountUrl!);
          if (bool != null && bool == true) {
            bloc.add(SetStripeAccountStatus());
            Alert.showSuccess(context, "Modifications sauvegardées.");
          } else {
            Alert.showError(context, "Votre compte Stripe est incomplet.");
          }
        }
        if (state is GetStripeLoginLinkSuccess) {
          await context.push("/influencer/complete_register/stripe/webview", extra: bloc.stripeLoginUrl!);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                CompleteInfluencerLegalInformationsBloc bloc = context.read<CompleteInfluencerLegalInformationsBloc>();
                if (state is GetStripeAccountLinkLoading) {
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
    );
  }

  String getText() {
    CompleteInfluencerLegalInformationsBloc bloc = context.read<CompleteInfluencerLegalInformationsBloc>();

    if (bloc.hasCompletedStripe) {
      return "stripe_payment_info_completed".translate();
    }

    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    CompleteInfluencerLegalInformationsBloc bloc = context.read<CompleteInfluencerLegalInformationsBloc>();

    if (bloc.hasCompletedStripe) {
      return "my_account".translate();
    }

    return "start".translate();
  }
}
