import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

class BillingInformations extends StatelessWidget {
  final Collaboration collaboration;
  final Company company;
  final Influencer influencer;
  const BillingInformations({super.key, required this.collaboration, required this.company, required this.influencer});

  @override
  Widget build(BuildContext context) {
    int price = collaboration.getPrice();
    bool hasInfluencerVAT = influencer.hasVATNumber();
    late double influencerVAT;

    double commission = price * kCommission;
    double rocinyVAT = commission * 0.20;

    double total = price + commission + rocinyVAT;
    if (hasInfluencerVAT) {
      influencerVAT = price * 0.20;
      total += influencerVAT;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("invoice".translate(), style: kTitle1Bold),
        const SizedBox(height: kPadding10),
        Row(
          children: [
            Text(
              "Collaboration HT",
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Text(
              "$price €",
              style: kBody,
            ),
          ],
        ),
        if (hasInfluencerVAT)
          Padding(
            padding: const EdgeInsets.only(top: kPadding5),
            child: Row(
              children: [
                Text(
                  "TVA Influenceur",
                  style: kBody.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Text(
                  "${influencerVAT.toStringAsFixed(0)} €",
                  style: kBody,
                ),
              ],
            ),
          ),
        const SizedBox(height: kPadding10),
        Row(
          children: [
            Text(
              "rociny_commission".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Text(
              "${commission.toStringAsFixed(0)} €",
              style: kBody,
            ),
          ],
        ),
        const SizedBox(height: kPadding5),
        Row(
          children: [
            Text(
              "TVA Rociny",
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Text(
              "${rocinyVAT.toStringAsFixed(0)} €",
              style: kBody,
            ),
          ],
        ),
        const SizedBox(height: kPadding20),
        Row(
          children: [
            Text(
              "${"total".translate()} (EUR)",
              style: kBodyBold,
            ),
            const Spacer(),
            Text(
              "${total.toStringAsFixed(0)} €",
              style: kBodyBold,
            ),
          ],
        ),
      ],
    );
  }
}
