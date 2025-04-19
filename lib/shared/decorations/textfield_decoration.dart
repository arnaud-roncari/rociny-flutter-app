import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/text_styles.dart';

final InputDecoration kTextFieldDecoration = InputDecoration(
  labelText: null,
  hintText: null,
  counterStyle: kCaption.copyWith(color: kGrey300),
  hintStyle: kBody.copyWith(color: kGrey500),
  contentPadding: const EdgeInsets.symmetric(vertical: 8),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kGrey100,
      width: 1,
    ),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kGrey100,
      width: 1,
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: kPrimary500,
      width: 1,
    ),
  ),
);
