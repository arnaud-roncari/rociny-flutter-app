import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';

class TimeLeft extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onComplete;

  const TimeLeft({
    super.key,
    this.duration = const Duration(minutes: 5),
    this.onComplete,
  });

  @override
  State<TimeLeft> createState() => _TimeLeftState();
}

class _TimeLeftState extends State<TimeLeft> {
  late Duration remainingTime;
  late Ticker ticker;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    ticker = Ticker((elapsed) {
      setState(() {
        remainingTime = widget.duration - elapsed;
        if (remainingTime.isNegative) {
          remainingTime = Duration.zero;
          ticker.stop();
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = remainingTime.inSeconds;

    final timeText = '$seconds ${"seconds_remaining".translate()}';

    return Text(
      timeText,
      style: kCaption.copyWith(color: kPrimary700),
    );
  }
}
