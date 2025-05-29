import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/settings_button.dart';
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
                  "legal_documents".translate(),
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            SettingsButton(
              label: "terms_of_service".translate(),
              onPressed: () {
                context.push("/preview_pdf", extra: "$kEndpoint/policy/privacy-policy");
              },
            ),
            const SizedBox(height: kPadding5),
            SettingsButton(
              label: "privacy_policy".translate(),
              onPressed: () {
                context.push("/preview_pdf", extra: "$kEndpoint/policy/terms-of-use");
              },
            ),
          ],
        ),
      )),
    );
  }
}
