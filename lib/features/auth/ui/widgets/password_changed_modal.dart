import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/button.dart';

class PasswordChangedModal extends StatelessWidget {
  const PasswordChangedModal({super.key});

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
            Text('password_changed'.translate(), style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              'password_changed_message'.translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding30),
            Button(
              title: "ok".translate(),
              onPressed: () => Navigator.of(context).popUntil((route) => route.settings.name == "/login"),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
