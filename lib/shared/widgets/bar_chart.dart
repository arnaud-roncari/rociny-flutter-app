import 'package:flutter/material.dart';
import 'package:rociny/core/constants/radius.dart';

class BarChart extends StatelessWidget {
  final double percent;
  final Color primaryColor;
  final Color secondaryColor;
  const BarChart({
    super.key,
    required this.percent,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxBarHeight = constraints.maxHeight;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Container(
              width: 20,
              height: percent * maxBarHeight,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(kRadius5),
              ),
            ),
            const Spacer(),
            Container(
              width: 20,
              height: (1 - percent) * maxBarHeight,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(kRadius5),
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
