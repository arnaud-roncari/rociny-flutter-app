import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/settings_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
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
                  "login_information".translate(),
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            SettingsButton(
              svgPath: "assets/svg/email.svg",
              label: "email_address".translate(),
              onPressed: () {
                context.push("/company/settings/credentials/email");
              },
            ),
            const SizedBox(height: kPadding5),
            SettingsButton(
              svgPath: "assets/svg/lock.svg",
              label: "password".translate(),
              onPressed: () {
                context.push("/company/settings/credentials/password");
              },
            ),
            const SizedBox(height: kPadding5),
            SettingsButton(
              svgPath: "assets/svg/instagram.svg",
              label: "Instagram",
              onPressed: () {
                context.push("/company/settings/credentials/instagram");
              },
            ),
          ],
        ),
      )),
    );
  }
}
