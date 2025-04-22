import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';

class SelectableChip extends StatefulWidget {
  final void Function() onTap;
  final String label;
  final bool isSelected;

  const SelectableChip({super.key, required this.onTap, required this.label, this.isSelected = false});

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadius100),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: kPadding15),
            child: Text(
              widget.label,
              style: getTextStyle(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration() {
    if (widget.isSelected) {
      return BoxDecoration(
        color: kPrimary500,
        borderRadius: BorderRadius.circular(kRadius100),
      );
    }
    return BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(kRadius100),
      border: Border.all(
        color: kGrey100,
        width: 0.5,
      ),
    );
  }

  TextStyle getTextStyle() {
    if (widget.isSelected) {
      return kCaption.copyWith(color: kWhite);
    }
    return kCaption;
  }
}
