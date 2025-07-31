import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/button.dart';

class CompanyWarningModal extends StatelessWidget {
  const CompanyWarningModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("incomplete_profile".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "complete_profile_to_collab".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding30),
          Button(
              title: "ok".translate(),
              onPressed: () {
                context.pop();
              }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
