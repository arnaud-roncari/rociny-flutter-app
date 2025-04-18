import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';

class DigitField extends StatefulWidget {
  final void Function(int) onCodeEntered;
  const DigitField({super.key, required this.onCodeEntered});

  @override
  State<DigitField> createState() => _DigitFieldState();
}

class _DigitFieldState extends State<DigitField> {
  final List<String> digits = List.filled(5, '');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: kPadding10),
            constraints: const BoxConstraints(maxWidth: 50),
            child: TextField(
              style: kBody,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                border: const UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kGrey100),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimary500),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  digits[index] = value.isNotEmpty ? value : '';
                });

                if (value.isNotEmpty && index < 4) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }

                if (digits.every((digit) => digit.isNotEmpty)) {
                  widget.onCodeEntered(int.parse(digits.join()));
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
