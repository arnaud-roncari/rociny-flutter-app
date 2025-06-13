import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_register/data/models/social_network_model.dart';

class InfluencerRepository {
  Future<String> updateProfilePicture(File image) async {
    var request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/influencer/update-profile-picture'),
    );

    request.files.add(
      await MultipartFile.fromPath('file', image.path),
    );

    request.headers['Authorization'] = 'Bearer $kJwt';

    StreamedResponse response = await request.send();
    String stringifiedBody = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(stringifiedBody);
      throw ApiException.fromJson(response.statusCode, body);
    }
    Map<String, dynamic> body = jsonDecode(stringifiedBody);
    return body["profile_picture"];
  }

  Future<List<String>> updatePortfolio(List<File> images) async {
    var request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/influencer/update-all-portfolio'),
    );

    for (var image in images) {
      request.files.add(
        await MultipartFile.fromPath('files', image.path),
      );
    }

    request.headers['Authorization'] = 'Bearer $kJwt';

    StreamedResponse response = await request.send();
    String stringifiedBody = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(stringifiedBody);
      throw ApiException.fromJson(response.statusCode, body);
    }

    Map<String, dynamic> body = jsonDecode(stringifiedBody);
    return List<String>.from(body["portfolio"]);
  }

  Future<void> updateName(String name) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-name'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateDescription(String description) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-description'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'description': description}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateDepartment(String department) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-department'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'department': department}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateThemes(List<String> themes) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-themes'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'themes': themes}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateTargetAudiences(List<String> targetAudiences) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-target-audience'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'target_audience': targetAudiences}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> addSocialNetwork(PlatformType platform, String url) async {
    var response = await post(
      Uri.parse('$kEndpoint/influencer/add-social-network'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'platform': platform.name,
        "url": url,
      }),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<List<SocialNetwork>> getSocialNetworks() async {
    var response = await get(
      Uri.parse('$kEndpoint/influencer/get-social-networks'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    List<dynamic> body = jsonDecode(response.body);
    return SocialNetwork.fromJsons(body);
  }

  Future<void> deleteSocialNetwork(int id) async {
    var response = await delete(
      Uri.parse('$kEndpoint/influencer/delete-social-network/$id'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateSocialNetwork(int id, String url) async {
    var response = await put(Uri.parse('$kEndpoint/influencer/update-social-network'),
        headers: {
          'Authorization': 'Bearer $kJwt',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": id.toString(),
          "url": url,
        }));

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> addLegalDocument(LegalDocumentType type, File file) async {
    final uri = Uri.parse('$kEndpoint/influencer/add-legal-document/${type.name}');
    final request = MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $kJwt'
      ..files.add(await MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode >= 400) {
      final body = await response.stream.bytesToString();
      throw ApiException.fromJson(response.statusCode, jsonDecode(body));
    }
  }

  Future<LegalDocumentStatus> getLegalDocumentStatus(LegalDocumentType type) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-legal-document-status/${type.name}'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    String s = jsonDecode(response.body)['status'];
    return LegalDocumentStatus.values.firstWhere(
      (e) => e.name == s,
    );
  }

  Future<void> deleteLegalDocument(String documentId) async {
    final response = await delete(
      Uri.parse('$kEndpoint/influencer/delete-legal-document/$documentId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<String> getStripeAccountUrl() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/stripe/account-link'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    String url = jsonDecode(response.body)['url'];
    return url;
  }

  Future<String> getStripeLoginUrl() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/stripe/login-link'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    String url = jsonDecode(response.body)['url'];
    return url;
  }

  Future<bool> hasCompletedLegalDocuments() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/has-completed/legal-documents'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    bool hasCompleted = jsonDecode(response.body)['has_completed'];
    return hasCompleted;
  }

  Future<bool> hasCompletedStripe() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/has-completed/stripe'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    bool hasCompleted = jsonDecode(response.body)['has_completed'];
    return hasCompleted;
  }

  Future<bool> hasInstagramAccount() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/has-instagram-account'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    bool hasCompleted = jsonDecode(response.body)['has_instagram_account'];
    return hasCompleted;
  }

  Future<InstagramAccount> getInstagramAccount() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/instagram'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    Map<String, dynamic> body = jsonDecode(response.body);
    return InstagramAccount.fromMap(body);
  }

  Future<void> createInstagramAccount(String fetchedInstagramAccountId) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/instagram/$fetchedInstagramAccountId'),
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
