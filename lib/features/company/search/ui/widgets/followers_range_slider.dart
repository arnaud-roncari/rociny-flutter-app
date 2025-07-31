import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';

/// Made with AI
class FollowersRangeSlider extends StatefulWidget {
  final Function(int min, int max) onChanged;
  final int? initialMin;
  final int? initialMax;

  const FollowersRangeSlider({
    super.key,
    required this.onChanged,
    this.initialMin,
    this.initialMax,
  });

  @override
  State<FollowersRangeSlider> createState() => _FollowersRangeSliderState();
}

class _FollowersRangeSliderState extends State<FollowersRangeSlider> {
  final List<int> followerSteps = [
    0,
    1000,
    5000,
    10000,
    25000,
    50000,
    100000,
    250000,
    500000,
    1000000,
    2000000,
  ];

  late RangeValues selectedRange;

  @override
  void initState() {
    super.initState();

    // Par défaut : 1K -> 1M
    int minVal = widget.initialMin ?? 1000;
    int maxVal = widget.initialMax ?? 1000000;

    int minIndex = _closestStepIndex(minVal);
    int maxIndex = _closestStepIndex(maxVal);

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
            max: (followerSteps.length - 1).toDouble(),
            activeColor: kPrimary500,
            inactiveColor: const Color.fromRGBO(246, 246, 246, 1),
            labels: RangeLabels(
              formatFollowers(followerSteps[selectedRange.start.round()]),
              formatFollowers(followerSteps[selectedRange.end.round()]),
            ),
            onChanged: (RangeValues values) {
              final snappedStart = _getClosestStep(values.start);
              final snappedEnd = _getClosestStep(values.end);

              setState(() {
                selectedRange = RangeValues(snappedStart, snappedEnd);
              });

              widget.onChanged(
                followerSteps[snappedStart.toInt()],
                followerSteps[snappedEnd.toInt()],
              );
            },
          ),
        ),
        const SizedBox(height: kPadding10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatFollowers(followerSteps[selectedRange.start.round()]),
              style: kCaption,
            ),
            Text(
              formatFollowers(followerSteps[selectedRange.end.round()]),
              style: kCaption,
            ),
          ],
        ),
      ],
    );
  }

  int _closestStepIndex(int value) {
    int closest = 0;
    int minDiff = (followerSteps[0] - value).abs();

    for (int i = 1; i < followerSteps.length; i++) {
      int diff = (followerSteps[i] - value).abs();
      if (diff < minDiff) {
        closest = i;
        minDiff = diff;
      }
    }

    return closest;
  }

  double _getClosestStep(double value) {
    return value.round().clamp(0, followerSteps.length - 1).toDouble();
  }

  String formatFollowers(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    } else {
      return value.toString();
    }
  }
}

class FullWidthTrackShape extends RoundedRectSliderTrackShape {
  const FullWidthTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
