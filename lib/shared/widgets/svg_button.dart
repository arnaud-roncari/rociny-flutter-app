import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';

class SvgButton extends StatelessWidget {
  final String path;
  final VoidCallback onPressed;
  final double iconSize;
  final Color color;

  const SvgButton({
    super.key,
    required this.path,
    this.iconSize = 20,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kRadius100),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadius100),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(kPadding5),
          child: SvgPicture.asset(
            path,
            width: iconSize,
            height: iconSize,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
