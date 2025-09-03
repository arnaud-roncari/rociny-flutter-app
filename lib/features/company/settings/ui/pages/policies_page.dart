import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/navigation_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
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
                  "legal_documents",
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            NavigationButton(
              label: "Conditions générales d'utilisation",
              onPressed: () {
                context.push("/preview_pdf/network", extra: "$kEndpoint/policy/privacy-policy");
              },
            ),
            const SizedBox(height: kPadding5),
            NavigationButton(
              label: "Politique de confidentialité",
              onPressed: () {
                context.push("/preview_pdf/network", extra: "$kEndpoint/policy/terms-of-use");
              },
            ),
          ],
        ),
      )),
    );
  }
}
