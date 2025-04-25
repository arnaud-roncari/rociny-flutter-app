import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_register/data/models/social_network_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialNetworkCard extends StatelessWidget {
  final SocialNetwork socialNetwork;
  final void Function(SocialNetwork) onDelete;
  final void Function(SocialNetwork) onUpdate;
  const SocialNetworkCard({super.key, required this.socialNetwork, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(kPadding5),
        onTap: () async {
          final Uri uri = Uri.parse(socialNetwork.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Row(
          children: [
            const SizedBox(width: kPadding10),
            SvgPicture.asset(
              getPlatformSvgAsset(socialNetwork.platform),
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(kBlack, BlendMode.srcIn),
            ),
            const SizedBox(width: kPadding10),
            Text(getDisplayedName(socialNetwork.platform), style: kBody),
            const Spacer(),
            PopupMenuButton<String>(
              tooltip: "",
              color: kWhite,
              icon: SvgPicture.asset(
                "assets/svg/menu_vertical.svg",
                width: 20,
                height: 20,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "update",
                    child: Text(
                      "Modifier",
                      style: kBody,
                    ),
                    onTap: () {
                      onUpdate(socialNetwork);
                    },
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    child: Text(
                      "Supprimer",
                      style: kBody,
                    ),
                    onTap: () {
                      onDelete(socialNetwork);
                    },
                  ),
                ];
              },
            ),
            const SizedBox(width: kPadding10),
          ],
        ),
      ),
    );
  }
}
