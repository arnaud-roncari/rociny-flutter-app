import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class StripeForm extends StatefulWidget {
  final bool isStripeCompleted;
  final void Function(bool isStripeCompleted) onPressed;

  const StripeForm({super.key, required this.isStripeCompleted, required this.onPressed});

  @override
  State<StripeForm> createState() => _StripeStateForm();
}

class _StripeStateForm extends State<StripeForm> {
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
          onTap: () async {
            widget.onPressed(widget.isStripeCompleted);
          },
        ),
        const Spacer(),
      ],
    );
  }

  String getText() {
    if (widget.isStripeCompleted) {
      return "stripe_payment_info_completed".translate();
    }

    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    if (widget.isStripeCompleted) {
      return "my_account".translate();
    }

    return "complete".translate();
  }
}
