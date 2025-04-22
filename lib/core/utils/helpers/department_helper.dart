import 'dart:convert';
import 'package:flutter/services.dart';

class DepartmentHelper {
  static Future<List<String>> loadDepartments() async {
    final String translationResponse = await rootBundle.loadString('assets/departments.json');
    final List<dynamic> departmentsJson = jsonDecode(translationResponse);

    return departmentsJson.map<String>((department) {
      return department['name'] as String;
    }).toList();
  }
}
