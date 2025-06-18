import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';

class SupportedPlatformChip extends StatefulWidget {
  final void Function() onTap;
  final PlatformType platform;
  final bool isSelected;

  const SupportedPlatformChip({super.key, required this.onTap, required this.platform, this.isSelected = false});

  @override
  State<SupportedPlatformChip> createState() => _SupportedPlatformChipState();
}

class _SupportedPlatformChipState extends State<SupportedPlatformChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadius100),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: kPadding15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  getPlatformSvgAsset(widget.platform),
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(widget.isSelected ? kWhite : kBlack, BlendMode.srcIn),
                ),
                const SizedBox(width: kPadding10),
                Text(
                  getDisplayedName(widget.platform),
                  style: getTextStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration() {
    if (widget.isSelected) {
      return BoxDecoration(
        color: kPrimary500,
        borderRadius: BorderRadius.circular(kRadius100),
      );
    }
    return BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(kRadius100),
      border: Border.all(
        color: kGrey100,
        width: 0.5,
      ),
    );
  }

  TextStyle getTextStyle() {
    if (widget.isSelected) {
      return kCaptionBold.copyWith(color: kWhite);
    }
    return kCaption;
  }
}
