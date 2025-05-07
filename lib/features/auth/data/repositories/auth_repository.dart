import 'dart:convert';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/dto/login_with_google_dto.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';

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

  Future<void> register(String email, String password, AccountType accountType) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "account_type": accountType.name,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<String> verifyRegisterCode(String email, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/register/verify"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "code": code,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    return body["access_token"];
  }

  Future<void> resentRegisterVerificationCode(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/register/resent-verification-code"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> forgotPassword(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/forgot-password"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> verifyForgotPasswordCode(String email, String password, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/forgot-password/verify"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "code": code,
        "password": password,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> resentForgotPasswordVerificationCode(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/forgot-password/resent-verification-code"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<LoginWithGoogleDto> loginWithGoogle(String idToken) async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/login-with-google/$idToken"),
    );

    Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }

    return LoginWithGoogleDto.fromJson(body);
  }

  Future<String> completeAuthGoogleUser(
    String providerUserId,
    AccountType accountType,
  ) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/complete-oauth-google-user"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "provider_user_id": providerUserId,
        "account_type": accountType.name,
      }),
    );

    Map<String, dynamic> body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }

    return body["access_token"];
  }
}
