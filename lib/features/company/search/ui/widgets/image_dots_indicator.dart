import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';

class ImageDotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const ImageDotsIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    const maxVisible = 5;
    final dots = <Widget>[];

    final showLeading = total > maxVisible && currentIndex > 2;
    final showTrailing = total > maxVisible && currentIndex < total - 3;

    // Dots start index
    int start = 0;
    if (total > maxVisible) {
      if (currentIndex <= 2) {
        start = 0;
      } else if (currentIndex >= total - 3) {
        start = total - 3;
      } else {
        start = currentIndex - 1;
      }
    }

    if (showLeading) {
      dots.add(_dot(isActive: false, isSmall: true));
    }

    for (int i = 0; i < (total > maxVisible ? 3 : total); i++) {
      final index = start + i;
      final isActive = index == currentIndex;
      dots.add(_dot(isActive: isActive));
    }

    if (showTrailing) {
      dots.add(_dot(isActive: false, isSmall: true));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  Widget _dot({required bool isActive, bool isSmall = false}) {
    final double size = isActive ? 5 : (isSmall ? 3 : 5);
    final Color color = isActive ? Colors.white : kGrey100;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}
