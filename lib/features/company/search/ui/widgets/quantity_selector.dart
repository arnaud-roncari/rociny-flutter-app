import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';

class QuantitySelector extends StatefulWidget {
  final void Function(int amount) onChanged;
  const QuantitySelector({super.key, required this.onChanged});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int amount = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(kRadius10)),
            onTap: () {
              setState(() {
                amount--;
                if (amount == 0) {
                  amount = 1;
                }
              });
              widget.onChanged(amount);
            },
            child: Center(
              child: Text(
                "-",
                style: kHeadline4,
              ),
            ),
          ),
        ),
        const SizedBox(width: kPadding10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: kGrey100,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              amount.toString(),
              style: kTitle2,
            ),
          ),
        ),
        const SizedBox(width: kPadding10),
        SizedBox(
          height: 50,
          width: 50,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(kRadius10)),
            onTap: () {
              setState(() {
                amount++;
              });
              widget.onChanged(amount);
            },
            child: Center(
              child: Text(
                "+",
                style: kHeadline4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
