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

  const BillingInformations({
    super.key,
    required this.collaboration,
    required this.company,
    required this.influencer,
  });

  /// Utility function to format prices:
  /// - If value has no decimals (e.g., 100.00) → display as "100"
  /// - If value has decimals → display with 2 digits (e.g., "100.25")
  String formatPrice(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Base collaboration price (without taxes or commission)
    int price = collaboration.getPrice();

    // Check if influencer has a VAT number
    bool hasInfluencerVAT = influencer.hasVATNumber();

    // VAT charged by influencer (only if VAT number exists)
    late double influencerVAT;

    // Rociny’s commission
    double commission = price * kCommission;

    // Rociny VAT (20% of commission)
    double rocinyVAT = commission * 0.20;

    // Total amount (base price + commission + Rociny VAT [+ influencer VAT if applicable])
    double total = price + commission + rocinyVAT;
    if (hasInfluencerVAT) {
      influencerVAT = price * 0.20;
      total += influencerVAT;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text("invoice".translate(), style: kTitle1Bold),
        const SizedBox(height: kPadding10),

        /// Base price row
        Row(
          children: [
            Text("Collaboration HT", style: kBody.copyWith(color: kGrey300)),
            const Spacer(),
            Text("${formatPrice(price.toDouble())} €", style: kBody),
          ],
        ),

        /// Influencer VAT row (only if influencer has VAT)
        if (hasInfluencerVAT)
          Padding(
            padding: const EdgeInsets.only(top: kPadding5),
            child: Row(
              children: [
                Text("TVA Influenceur", style: kBody.copyWith(color: kGrey300)),
                const Spacer(),
                Text("${formatPrice(influencerVAT)} €", style: kBody),
              ],
            ),
          ),

        const SizedBox(height: kPadding10),

        /// Rociny commission row
        Row(
          children: [
            Text("rociny_commission".translate(), style: kBody.copyWith(color: kGrey300)),
            const Spacer(),
            Text("${formatPrice(commission)} €", style: kBody),
          ],
        ),

        const SizedBox(height: kPadding5),

        /// Rociny VAT row
        Row(
          children: [
            Text("TVA Rociny", style: kBody.copyWith(color: kGrey300)),
            const Spacer(),
            Text("${formatPrice(rocinyVAT)} €", style: kBody),
          ],
        ),

        const SizedBox(height: kPadding20),

        /// Total row (final amount to pay)
        Row(
          children: [
            Text("${"total".translate()} (EUR)", style: kBodyBold),
            const Spacer(),
            Text("${formatPrice(total)} €", style: kBodyBold),
          ],
        ),
      ],
    );
  }
}
