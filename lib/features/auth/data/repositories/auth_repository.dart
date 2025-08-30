import 'dart:convert';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/dto/login_with_provider_dto.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/data/models/fetched_instagram_account_model.dart';

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

  Future<void> updateEmail(String newEmail, String password) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/update-email"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({
        "new_email": newEmail,
        "password": password,
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

  Future<void> verifyUpdateEmailCode(String newEmail, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/update-email/verify"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({
        "new_email": newEmail,
        "code": code,
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

  Future<void> resentUpdateEmailVerificationCode(String newEmail) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/update-email/resent-verification-code"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({
        "new_email": newEmail,
      }),
    );
    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<LoginWithProviderDto> loginWithGoogle(String idToken) async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/login-with-google/$idToken"),
    );

    Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }

    return LoginWithProviderDto.fromJson(body);
  }

  Future<LoginWithProviderDto> loginWithApple(String idToken) async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/login-with-apple/$idToken"),
    );

    Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }

    return LoginWithProviderDto.fromJson(body);
  }

  Future<String> completeOAuthUser(
    String providerUserId,
    AccountType accountType,
  ) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/user/auth/complete-oauth-user"),
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

  Future<bool> isRegisteredLocally() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/is-registered-locally"),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }

    return (body["is_registered_locally"]);
  }

  Future<void> updatePassword(
    String password,
    String newPassword,
  ) async {
    final Response response = await put(
      Uri.parse("$kEndpoint/user/auth/update-password"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({
        "password": password,
        "new_password": newPassword,
      }),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> deleteAccount() async {
    final Response response = await delete(
      Uri.parse("$kEndpoint/user/auth/delete-user"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<List<FetchedInstagramAccount>> getInstagramAccounts() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/facebook/instagram-accounts"),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    List<dynamic> body = jsonDecode(response.body);
    return FetchedInstagramAccount.fromMaps(body);
  }

  Future<bool> hasFacebookSession() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/user/auth/facebook/has-session"),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    return (body["has_session"]);
  }

  Future<void> logoutFacebook() async {
    final Response response = await delete(
      Uri.parse("$kEndpoint/user/auth/facebook/logout"),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> addDevice(String onesignalId) async {
    final response = await post(
      Uri.parse('$kEndpoint/user/auth/register-device'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'onesignal_id': onesignalId,
      }),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> removeDevice(String onesignalId) async {
    final response = await delete(
      Uri.parse('$kEndpoint/user/auth/delete-device/$onesignalId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }
}
