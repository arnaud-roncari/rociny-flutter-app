import 'package:flutter/material.dart';
import 'dart:math';

/// Made with ai
class DonutChart extends StatelessWidget {
  final double percent;
  final Color primaryColor;
  final Color secondaryColor;
  final double gapDegree;
  final double strokeWidth;

  const DonutChart({
    super.key,
    required this.percent,
    this.primaryColor = Colors.teal,
    this.secondaryColor = Colors.grey,
    this.gapDegree = 6,
    this.strokeWidth = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutChartPainter(
        percent: percent,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        gapDegree: gapDegree,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double percent;
  final Color primaryColor;
  final Color secondaryColor;
  final double gapDegree;
  final double strokeWidth;

  _DonutChartPainter({
    required this.percent,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gapDegree,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth / 2;
    final center = size.center(Offset.zero);

    final gapRadians = degToRad(gapDegree);

    final paintPrimary = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintSecondary = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const fullCircle = 2 * pi;

    final sweepPrimary = fullCircle * percent - gapRadians;
    final sweepSecondary = fullCircle * (1 - percent) - gapRadians;

    final startPrimary = -pi / 2 + gapRadians / 2;
    final startSecondary = startPrimary + sweepPrimary + gapRadians;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, startPrimary, sweepPrimary, false, paintPrimary);

    canvas.drawArc(rect, startSecondary, sweepSecondary, false, paintSecondary);
  }

  double degToRad(double deg) => deg * pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
