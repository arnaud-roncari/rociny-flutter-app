import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/social_network_sheet_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/supported_platforms_sheet.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class UpdateSocialNetworksForm extends StatefulWidget {
  final List<SocialNetwork> initialValue;
  final void Function(int id, String url) onUpdated;
  final void Function(PlatformType, String url) onAdded;
  final void Function(int id) onDeleted;
  const UpdateSocialNetworksForm({
    super.key,
    required this.initialValue,
    required this.onUpdated,
    required this.onAdded,
    required this.onDeleted,
  });

  @override
  State<UpdateSocialNetworksForm> createState() => _UpdateSocialNetworksFormState();
}

class _UpdateSocialNetworksFormState extends State<UpdateSocialNetworksForm> {
  List<PlatformType> platforms = [
    PlatformType.linkedin,
    PlatformType.x,
    PlatformType.youtube,
    PlatformType.tiktok,
    PlatformType.twitch,
    PlatformType.instagram,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "social_networks".translate(),
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "add_your_social_networks".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const SizedBox(height: kPadding20),
        ChipButton(
          label: "add".translate(),
          svgPath: "assets/svg/add.svg",
          onTap: () async {
            showModalBottomSheet(
              context: context,
              backgroundColor: kWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
              ),
              builder: (context) {
                return SupportedPlatformsSheet(
                  platforms: platforms,
                  onTap: (platform, url) {
                    widget.onAdded(platform, url);
                    context.pop();
                  },
                );
              },
            );
          },
        ),

        /// Social Networks
        const SizedBox(height: kPadding30),
        Column(
          children: List.generate(widget.initialValue.length, (i) {
            SocialNetwork sn = widget.initialValue[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: kPadding10),
              child: SocialNetworkCard(
                socialNetwork: sn,
                onDelete: (toDelete) {
                  widget.onDeleted(sn.id);
                },
                onUpdate: (sn) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: kWhite,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
                    ),
                    builder: (context) {
                      return SupportedPlatformsSheet(
                        type: SocialNetworkSheetType.udpate,
                        selectedSocialNetwork: sn,
                        platforms: platforms,
                        onTap: (platform, url) {
                          widget.onUpdated(sn.id, url);
                          context.pop();
                        },
                      );
                    },
                  );
                },
              ),
            );
          }),
        ),
        const Spacer(),
      ],
    );
  }
}
