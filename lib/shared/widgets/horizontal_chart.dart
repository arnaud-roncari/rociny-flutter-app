import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';

class HorizontalChart extends StatelessWidget {
  final double percent;
  const HorizontalChart({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        height: 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(206, 206, 206, 0.3),
          borderRadius: BorderRadius.circular(2.5),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 10,
            width: constraint.maxWidth * percent,
            decoration: BoxDecoration(
              color: kPrimary500,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
      );
    });
  }
}
