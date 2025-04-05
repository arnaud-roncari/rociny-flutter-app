import 'dart:convert';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';

class AuthRepository {
  Future<String> login(String email, String password) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    // Usually, data should be cast to a model, such as entities in NestJS.
    // But since this is a specific scenario, we don't need to create a model just for a string (the JWT).
    return body["access_token"];
  }
}
