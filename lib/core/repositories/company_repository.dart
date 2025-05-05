import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/company/complete_register/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_register/data/models/social_network_model.dart';

class CompanyRepository {
  Future<String> updateProfilePicture(File image) async {
    var request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/company/update-profile-picture'),
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

  Future<void> updateName(String name) async {
    var response = await put(
      Uri.parse('$kEndpoint/company/update-name'),
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
      Uri.parse('$kEndpoint/company/update-description'),
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
      Uri.parse('$kEndpoint/company/update-department'),
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

  Future<void> addSocialNetwork(PlatformType platform, String url) async {
    var response = await post(
      Uri.parse('$kEndpoint/company/add-social-network'),
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
      Uri.parse('$kEndpoint/company/get-social-networks'),
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
      Uri.parse('$kEndpoint/company/delete-social-network/$id'),
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
    var response = await put(Uri.parse('$kEndpoint/company/update-social-network'),
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
    final uri = Uri.parse('$kEndpoint/company/add-legal-document/${type.name}');
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
      Uri.parse('$kEndpoint/company/get-legal-document-status/${type.name}'),
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
      Uri.parse('$kEndpoint/company/delete-legal-document/$documentId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<SetupIntentDto> createSetupIntent() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/create-setup-intent'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return SetupIntentDto.fromJson(body);
  }
}
