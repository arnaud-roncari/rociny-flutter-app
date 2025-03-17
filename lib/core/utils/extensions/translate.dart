import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rociny/core/config/environment.dart';

extension TranslationExtension on String {
  static Map<String, Map<String, String>> translations = {};
  static bool _loaded = false;

  /// Translate the string to the current language
  String translate() {
    if (translations.containsKey(this)) {
      final Map<String, String> translation = translations[this]!;
      if (translation.containsKey(kLanguage)) {
        String translated = translation[kLanguage]!;
        return translated;
      }
    }
    return '<unknown translation "$this">';
  }

  /// Load the translation files and convert them into a Map.
  static Future<void> loadTranslations() async {
    if (_loaded) {
      return;
    }

    try {
      final String translationResponse = await rootBundle.loadString('assets/translations.json');
      final Map<String, dynamic> translationsJson = jsonDecode(translationResponse);

      translations = translationsJson.map((key, value) {
        return MapEntry<String, Map<String, String>>(
          key,
          (value as Map<String, dynamic>).cast(),
        );
      });

      _loaded = true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
