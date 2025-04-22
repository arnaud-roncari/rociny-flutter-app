import 'dart:convert';
import 'package:flutter/services.dart';

class TargetAudienceHelper {
  static Future<List<String>> loadTargetAudience() async {
    final String translationResponse = await rootBundle.loadString('assets/target_audience.json');
    final List<dynamic> json = jsonDecode(translationResponse);

    return json.map<String>((i) {
      return i as String;
    }).toList();
  }
}
