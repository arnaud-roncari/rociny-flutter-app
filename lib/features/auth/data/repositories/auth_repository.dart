import 'dart:convert';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/dto/login_with_provider_dto.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/data/models/fetched_instagram_account_model.dart';

class AuthRepository {
  /// Logs a user in with email and password.
  Future<String> login(String email, String password) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["access_token"];
  }

  /// Registers a new user with email, password, and account type.
  Future<void> register(String email, String password, AccountType accountType) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
        "account_type": accountType.name,
      }),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Verifies registration code and returns JWT.
  Future<String> verifyRegisterCode(String email, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/register/verify"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "code": code}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["access_token"];
  }

  /// Resends registration verification code.
  Future<void> resendRegisterVerificationCode(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/register/resend-code"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Starts forgot password flow by sending code.
  Future<void> forgotPassword(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/password/forgot"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Verifies forgot password code and sets a new password.
  Future<void> verifyForgotPasswordCode(String email, String password, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/password/forgot/verify"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "code": code, "password": password}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Resends forgot password verification code.
  Future<void> resendForgotPasswordVerificationCode(String email) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/password/forgot/resend-code"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Updates password for logged-in user.
  Future<void> updatePassword(String password, String newPassword) async {
    final Response response = await put(
      Uri.parse("$kEndpoint/auth/password/update"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({"password": password, "new_password": newPassword}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Requests email update for logged-in user.
  Future<void> updateEmail(String newEmail, String password) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/email/update"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({"new_email": newEmail, "password": password}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Verifies email update with a code.
  Future<void> verifyUpdateEmailCode(String newEmail, int code) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/email/update/verify"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({"new_email": newEmail, "code": code}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Resends update email verification code.
  Future<void> resendUpdateEmailVerificationCode(String newEmail) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/email/update/resend-code"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
      body: jsonEncode({"new_email": newEmail}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Deletes current user account.
  Future<void> deleteAccount() async {
    final Response response = await delete(
      Uri.parse("$kEndpoint/auth/delete"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $kJwt',
      },
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Checks if user is registered locally (email/password).
  Future<bool> isRegisteredLocally() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/auth/is-registered-locally"),
      headers: {'Authorization': 'Bearer $kJwt'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["is_registered_locally"];
  }

  /// Logs in with Google OAuth.
  Future<LoginWithProviderDto> loginWithGoogle(String idToken) async {
    final Response response = await get(Uri.parse("$kEndpoint/auth/login/google/$idToken"));
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return LoginWithProviderDto.fromJson(body);
  }

  /// Logs in with Apple OAuth.
  Future<LoginWithProviderDto> loginWithApple(String idToken) async {
    final Response response = await get(Uri.parse("$kEndpoint/auth/login/apple/$idToken"));
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return LoginWithProviderDto.fromJson(body);
  }

  /// Completes OAuth flow (Google, Apple, Facebook).
  Future<String> completeOAuthUser(String providerUserId, AccountType accountType) async {
    final Response response = await post(
      Uri.parse("$kEndpoint/auth/oauth/complete"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "provider_user_id": providerUserId,
        "account_type": accountType.name,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["access_token"];
  }

  /// Retrieves Instagram accounts connected via Facebook.
  Future<List<FetchedInstagramAccount>> getInstagramAccounts() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/auth/facebook/instagram-accounts"),
      headers: {'Authorization': 'Bearer $kJwt'},
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
    final body = jsonDecode(response.body) as List<dynamic>;
    return FetchedInstagramAccount.fromMaps(body);
  }

  /// Checks if Facebook session exists.
  Future<bool> hasFacebookSession() async {
    final Response response = await get(
      Uri.parse("$kEndpoint/auth/facebook/session"),
      headers: {'Authorization': 'Bearer $kJwt'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["has_session"];
  }

  /// Logs out user from Facebook and clears Instagram data.
  Future<void> logoutFacebook() async {
    final Response response = await delete(
      Uri.parse("$kEndpoint/auth/facebook/logout"),
      headers: {'Authorization': 'Bearer $kJwt'},
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Registers a device for push notifications.
  Future<void> addDevice(String onesignalId) async {
    final response = await post(
      Uri.parse('$kEndpoint/auth/devices'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'onesignal_id': onesignalId}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Removes a registered device by OneSignal ID.
  Future<void> removeDevice(String onesignalId) async {
    final response = await delete(
      Uri.parse('$kEndpoint/auth/devices'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'onesignal_id': onesignalId}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }
}
