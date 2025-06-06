import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';

class Button extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Function onPressed;
  const Button({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? kPrimary500,
        borderRadius: BorderRadius.circular(kRadius100),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadius100),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadius100),
          onTap: () {
            onPressed();
          },
          child: Center(
            child: Text(
              title,
              style: kTitle2.copyWith(color: kWhite),
            ),
          ),
        ),
      ),
    );
  }
}
