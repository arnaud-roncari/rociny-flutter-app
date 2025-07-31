import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/search/ui/widgets/followers_range_slider.dart';

/// Made with AI
class EngagementRangeSlider extends StatefulWidget {
  final Function(double min, double max) onChanged;
  final double? initialMin;
  final double? initialMax;

  const EngagementRangeSlider({
    super.key,
    required this.onChanged,
    this.initialMin,
    this.initialMax,
  });

  @override
  State<EngagementRangeSlider> createState() => _EngagementRangeSliderState();
}

class _EngagementRangeSliderState extends State<EngagementRangeSlider> {
  final List<double> engagementSteps = [
    0,
    0.5,
    1,
    2,
    3,
    5,
    10,
    15,
    20,
  ];

  late RangeValues selectedRange;

  @override
  void initState() {
    super.initState();

    final minVal = widget.initialMin ?? 1.0;
    final maxVal = widget.initialMax ?? 10.0;

    final minIndex = _closestStepIndex(minVal);
    final maxIndex = _closestStepIndex(maxVal);

    selectedRange = RangeValues(minIndex.toDouble(), maxIndex.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: const FullWidthTrackShape(),
            overlayShape: SliderComponentShape.noOverlay,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: selectedRange,
            min: 0,
            max: (engagementSteps.length - 1).toDouble(),
            activeColor: kPrimary500,
            inactiveColor: const Color.fromRGBO(246, 246, 246, 1),
            labels: RangeLabels(
              formatPercent(engagementSteps[selectedRange.start.round()]),
              formatPercent(engagementSteps[selectedRange.end.round()]),
            ),
            onChanged: (RangeValues values) {
              final snappedStart = _getClosestStep(values.start);
              final snappedEnd = _getClosestStep(values.end);

              setState(() {
                selectedRange = RangeValues(snappedStart, snappedEnd);
              });

              widget.onChanged(
                engagementSteps[snappedStart.toInt()],
                engagementSteps[snappedEnd.toInt()],
              );
            },
          ),
        ),
        const SizedBox(height: kPadding10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatPercent(engagementSteps[selectedRange.start.round()]),
              style: kCaption,
            ),
            Text(
              formatPercent(engagementSteps[selectedRange.end.round()]),
              style: kCaption,
            ),
          ],
        ),
      ],
    );
  }

  int _closestStepIndex(double value) {
    int closest = 0;
    double minDiff = (engagementSteps[0] - value).abs();

    for (int i = 1; i < engagementSteps.length; i++) {
      double diff = (engagementSteps[i] - value).abs();
      if (diff < minDiff) {
        closest = i;
        minDiff = diff;
      }
    }

    return closest;
  }

  double _getClosestStep(double value) {
    return value.round().clamp(0, engagementSteps.length - 1).toDouble();
  }

  String formatPercent(double value) {
    if (value < 1) {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}%';
    }
  }
}
