import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';

BoxDecoration kContainerShadow = BoxDecoration(
  borderRadius: BorderRadius.circular(kRadius10),
  color: kWhite,
  boxShadow: [
    BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 0,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
