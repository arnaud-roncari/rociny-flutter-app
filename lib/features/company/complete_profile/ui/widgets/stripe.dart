import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
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
    return BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
      listener: (context, state) async {},
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
                if (state is CreateSetupIntentLoading) {
                  return;
                }
                context.read<CompleteProfileBloc>().add(CreateSetupIntent());
              },
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  String getText() {
    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    return "Ajouter un moyen de paiement";
  }
}
