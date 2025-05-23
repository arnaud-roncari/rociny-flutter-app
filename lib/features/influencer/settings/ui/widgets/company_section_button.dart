import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';

class CompanySectionButton extends StatelessWidget {
  final void Function() onTap;
  final bool isCompleted;
  final String name;
  const CompanySectionButton({super.key, required this.onTap, required this.isCompleted, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: kBody,
              ),
              const Spacer(),
              SvgPicture.asset(
                "assets/svg/right_arrow.svg",
                width: 20,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: kPadding5),
          Text(
            isCompleted ? "Terminé" : "À remplir",
            style: kCaption.copyWith(color: isCompleted ? kGreen500 : kRed500),
          ),
          const SizedBox(height: kPadding10),
          Container(
            height: 1,
            width: double.infinity,
            color: kGrey100,
          )
        ],
      ),
    );
  }
}
