import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';

class ChipButton extends StatefulWidget {
  final void Function() onTap;
  final String label;
  final String? svgPath;
  final double? iconSize;

  const ChipButton({super.key, required this.onTap, required this.label, this.svgPath, this.iconSize = 15});

  @override
  State<ChipButton> createState() => _ChipButtonState();
}

class _ChipButtonState extends State<ChipButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimary500,
        borderRadius: BorderRadius.circular(kRadius100),
      ),
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
                if (widget.svgPath != null)
                  Padding(
                    padding: const EdgeInsets.only(right: kPadding5),
                    child: SvgPicture.asset(
                      widget.svgPath!,
                      width: widget.iconSize,
                      height: widget.iconSize,
                      colorFilter: ColorFilter.mode(kWhite, BlendMode.srcIn),
                    ),
                  ),
                Text(
                  widget.label,
                  style: kBody.copyWith(color: kWhite),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
