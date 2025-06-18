import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/social_network_sheet_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/supported_platform_chip.dart';

class SupportedPlatformsSheet extends StatefulWidget {
  final SocialNetworkSheetType type;
  final SocialNetwork? selectedSocialNetwork;
  final List<PlatformType> platforms;
  final Function(PlatformType platform, String url) onTap;
  const SupportedPlatformsSheet(
      {super.key,
      required this.platforms,
      required this.onTap,
      this.type = SocialNetworkSheetType.add,
      this.selectedSocialNetwork});

  @override
  State<SupportedPlatformsSheet> createState() => _SupportedPlatformsSheetState();
}

class _SupportedPlatformsSheetState extends State<SupportedPlatformsSheet> {
  TextEditingController controller = TextEditingController();
  PlatformType? selectedPlatform;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.type == SocialNetworkSheetType.udpate) {
      if (widget.selectedSocialNetwork == null) {
        throw Exception("Provide selected platform");
      }
      selectedPlatform = widget.selectedSocialNetwork!.platform;
      controller.text = widget.selectedSocialNetwork!.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'social_network'.translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              getDescription(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            Wrap(
              spacing: kPadding10,
              runSpacing: kPadding10,
              children: List.generate(widget.platforms.length, (index) {
                final PlatformType platform = widget.platforms[index];
                final bool isSelected = platform == selectedPlatform;

                return SupportedPlatformChip(
                  platform: platform,
                  onTap: () {
                    if (widget.type == SocialNetworkSheetType.udpate) {
                      return;
                    }

                    setState(() {
                      selectedPlatform = platform;
                    });
                  },
                  isSelected: isSelected,
                );
              }),
            ),
            const SizedBox(height: kPadding20),
            TextFormField(
              controller: controller,
              style: kBody,
              decoration: kTextFieldDecoration.copyWith(hintText: "URL"),
              validator: Validator.isNotEmpty,
            ),
            const SizedBox(height: kPadding30),
            Button(
                title: getButtonLabel(),
                onPressed: () {
                  if (formKey.currentState!.validate() && selectedPlatform != null) {
                    widget.onTap(selectedPlatform!, controller.text);
                  }
                }),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  String getDescription() {
    if (widget.type == SocialNetworkSheetType.udpate) {
      return "select_social_network_edit_url".translate();
    }

    return "select_social_network_add_url".translate();
  }

  String getButtonLabel() {
    if (widget.type == SocialNetworkSheetType.udpate) {
      return "edit".translate();
    }
    return "add".translate();
  }
}
