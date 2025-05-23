import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/notification_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO Implement notification settings
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                  "notifications".translate(),
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            NotificationButton(
              initialValue: true,
              title: "new_message",
              description: "notification_on_message_from_influencer".translate(),
              onTap: (_) {},
            ),
            const SizedBox(height: kPadding5),
            NotificationButton(
              initialValue: true,
              title: "Nom de notification",
              description: "Description de notification.",
              onTap: (_) {},
            ),
            const SizedBox(height: kPadding5),
            NotificationButton(
              initialValue: false,
              title: "Nom de notification",
              description: "Description de notification.",
              onTap: (_) {},
            ),
            const SizedBox(height: kPadding5),
            NotificationButton(
              initialValue: false,
              title: "Nom de notification",
              description: "Description de notification.",
              onTap: (_) {},
            ),
          ],
        ),
      )),
    );
  }
}
