import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';

/// TODO translate
class WarningModal extends StatelessWidget {
  final ProfileCompletionStatus status;
  const WarningModal({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kPadding20),
          topRight: Radius.circular(kPadding20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Votre compte', style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              'Afin de proposer des collaborations, assurez-vous de compléter votre profil et de renseigner les informations juridiques de votre entreprise.',
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding30),
            if (!status.hasCompletedProfile())
              Padding(
                padding: const EdgeInsets.only(bottom: kPadding10),
                child: Text(
                  "Complétez votre profil.",
                  style: kBody.copyWith(color: kRed500),
                ),
              ),
            if (!status.hasCompletedLegal())
              Padding(
                padding: const EdgeInsets.only(bottom: kPadding10),
                child: Text(
                  "Complétez vos informations juridiques.",
                  style: kBody.copyWith(color: kRed500),
                ),
              ),
            if (!status.hasCompletedInstagram())
              Padding(
                padding: const EdgeInsets.only(bottom: kPadding10),
                child: Text(
                  "Connectez-vous à Instagram.",
                  style: kBody.copyWith(color: kRed500),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
