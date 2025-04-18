import 'package:flutter/material.dart';

const String fontFamily = "Nunito";

/// Regular
TextStyle kHeadline1 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 48, height: 1);
TextStyle kHeadline2 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 40, height: 1);
TextStyle kHeadline3 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 33, height: 1);
TextStyle kHeadline4 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 28, height: 1);
TextStyle kHeadline5 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 23, height: 1);
TextStyle kTitle1 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 19, height: 1);
TextStyle kTitle2 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 16, height: 1);
TextStyle kTitle3 = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 14.5, height: 1);
TextStyle kBody = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 13, height: 1);
TextStyle kCaption = const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.normal, fontSize: 11, height: 1);

/// Bold
TextStyle kHeadline1Bold = kHeadline1.copyWith(fontWeight: FontWeight.bold);
TextStyle kHeadline2Bold = kHeadline2.copyWith(fontWeight: FontWeight.bold);
TextStyle kHeadline3Bold = kHeadline3.copyWith(fontWeight: FontWeight.bold);
TextStyle kHeadline4Bold = kHeadline4.copyWith(fontWeight: FontWeight.bold);
TextStyle kHeadline5Bold = kHeadline5.copyWith(fontWeight: FontWeight.bold);
TextStyle kTitle1Bold = kTitle1.copyWith(fontWeight: FontWeight.bold);
TextStyle kTitle2Bold = kTitle2.copyWith(fontWeight: FontWeight.bold);
TextStyle kTitle3Bold = kTitle3.copyWith(fontWeight: FontWeight.bold);
TextStyle kBodyBold = kBody.copyWith(fontWeight: FontWeight.bold);
TextStyle kCaptionBold = kCaption.copyWith(fontWeight: FontWeight.bold);
