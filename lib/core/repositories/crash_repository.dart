import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';

class CrashRepository {
  Future<void> registerCrash(dynamic exception, StackTrace stack) async {
    if (kDebugMode) {
      print("$exception");
      print(stack);
    } else {
      await post(
        Uri.parse("$kEndpoint/crash/create-crash"),
        headers: {
          'Authorization': 'Bearer $kJwt',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "exception": "$exception",
          "stack": stack.toString(),
        }),
      );
    }
  }
}
