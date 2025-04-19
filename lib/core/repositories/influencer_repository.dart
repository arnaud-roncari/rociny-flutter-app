import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';

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

  Future<void> updateTargetAudience(List<String> targetAudience) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-target-audience'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'target_audience': targetAudience}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }
}
