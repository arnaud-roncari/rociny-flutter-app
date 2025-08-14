import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';

class InstagramAccountCard extends StatelessWidget {
  final InstagramAccount instagramAccount;
  const InstagramAccountCard({super.key, required this.instagramAccount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: kPadding10),
          if (instagramAccount.profilePictureUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: kPadding10),
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(instagramAccount.profilePictureUrl!),
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(instagramAccount.name, style: kBody),
              const SizedBox(height: kPadding5),
              Text(
                "${instagramAccount.followersCount?.toString() ?? "0"} ${"followers".translate()}",
                style: kCaption.copyWith(color: kGrey300),
              ),
            ],
          ),
          const SizedBox(width: kPadding10),
        ],
      ),
    );
  }
}
