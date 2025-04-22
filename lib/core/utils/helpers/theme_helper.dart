import 'dart:convert';
import 'package:flutter/services.dart';

class ThemeHelper {
  static Future<List<String>> loadThemes() async {
    final String translationResponse = await rootBundle.loadString('assets/themes.json');
    final List<dynamic> json = jsonDecode(translationResponse);

    return json.map<String>((i) {
      return i as String;
    }).toList();
  }
}
