import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';

/// TODO rename
class SettingsButton extends StatelessWidget {
  final String? svgPath;
  final String label;
  final void Function() onPressed;
  const SettingsButton({super.key, this.svgPath, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kGrey100,
            width: 1.0,
          ),
        ),
      ),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: Row(
          children: [
            if (svgPath != null)
              Padding(
                padding: const EdgeInsets.only(right: kPadding15),
                child: SvgPicture.asset(
                  svgPath!,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(kBlack, BlendMode.srcIn),
                ),
              ),
            Text(label, style: kBody),
            const Spacer(),
            SvgPicture.asset(
              "assets/svg/right_arrow.svg",
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(kGrey300, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
