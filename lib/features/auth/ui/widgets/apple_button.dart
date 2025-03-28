import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';

class AppleButton extends StatelessWidget {
  const AppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(kRadius10)),
        border: Border.all(
          color: kGrey100,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadius10),
        onTap: () {
          /// ...
        },
        child: Center(
          child: SvgPicture.asset(
            "assets/svg/apple_logo.svg",
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
  }
}
