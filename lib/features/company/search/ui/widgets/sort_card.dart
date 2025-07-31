import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';

class SortCard extends StatefulWidget {
  final String label;
  final String svg;
  final bool initialValue;
  final Function(bool) onPressed;
  const SortCard(
      {super.key, required this.label, required this.svg, required this.initialValue, required this.onPressed});

  @override
  State<SortCard> createState() => _SortCardState();
}

class _SortCardState extends State<SortCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadius10),
        onTap: () {
          widget.onPressed(!widget.initialValue);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                SvgPicture.asset(
                  widget.svg,
                  width: 10,
                  height: 10,
                  colorFilter: ColorFilter.mode(getColor(), BlendMode.srcIn),
                ),
                const SizedBox(width: kPadding10),
                Text(
                  widget.label,
                  style: getTextStyle(),
                ),
                const Spacer(),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: getColor(),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(kRadius100),
                  ),
                  child: Center(
                    child: Container(
                      height: 9,
                      width: 9,
                      decoration: BoxDecoration(
                        color: widget.initialValue ? kBlack : Colors.transparent,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getColor() {
    return widget.initialValue ? kBlack : kGrey300;
  }

  TextStyle getTextStyle() {
    return widget.initialValue ? kBodyBold : kBody.copyWith(color: kGrey300);
  }
}
