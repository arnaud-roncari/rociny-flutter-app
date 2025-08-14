import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class Notation extends StatelessWidget {
  final int stars;
  const Notation({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgButton(
          path: getPath(stars >= 1),
          color: kBlack,
          onPressed: () {},
        ),
        SvgButton(
          path: getPath(stars >= 2),
          color: kBlack,
          onPressed: () {},
        ),
        SvgButton(
          path: getPath(stars >= 3),
          color: kBlack,
          onPressed: () {},
        ),
        SvgButton(
          path: getPath(stars >= 4),
          color: kBlack,
          onPressed: () {},
        ),
        SvgButton(
          path: getPath(stars >= 5),
          color: kBlack,
          onPressed: () {},
        ),
      ],
    );
  }

  String getPath(bool isNotEmpty) {
    if (isNotEmpty) {
      return "assets/svg/star.svg";
    }
    return "assets/svg/star_empty.svg";
  }
}
