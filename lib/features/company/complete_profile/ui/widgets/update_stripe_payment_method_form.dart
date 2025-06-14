import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class UpdateStripePaymentMethodForm extends StatefulWidget {
  final void Function() onUpdated;

  const UpdateStripePaymentMethodForm({super.key, required this.onUpdated});

  @override
  State<UpdateStripePaymentMethodForm> createState() => _UpdateStripePaymentMethodFormState();
}

class _UpdateStripePaymentMethodFormState extends State<UpdateStripePaymentMethodForm> {
  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            widget.onUpdated();
          },
        ),
        const Spacer(),
      ],
    );
  }

  String getText() {
    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    return "Ajouter un moyen de paiement";
  }
}
