import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/company/complete_profile/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/inlfuencer_filters.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart' as i;

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

  Future<bool> hasCompletedLegalDocuments() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/has-completed/legal-documents'),
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
      Uri.parse('$kEndpoint/company/has-completed/stripe'),
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

  Future<String> getBillingPortalSession() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/stripe/billing-portal-session'),
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

  Future<bool> hasInstagramAccount() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/has-instagram-account'),
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
      Uri.parse('$kEndpoint/company/instagram'),
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
      Uri.parse('$kEndpoint/company/instagram/$fetchedInstagramAccountId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<ProfileCompletionStatus> getProfileCompletionStatus() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-profile-completion-status'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return ProfileCompletionStatus.fromMap(body);
  }

  Future<bool> hasCompletedProfile() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/has-completed-profile'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return body['has_completed_profile'] as bool;
  }

  Future<Company> getCompany() async {
    final response = await get(
      Uri.parse('$kEndpoint/company'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return Company.fromMap(body);
  }

  Future<List<InfluencerSummary>> searchInfluencersByTheme({String? theme}) async {
    final uri = Uri.parse('$kEndpoint/company/search-influencers-by-theme');

    final response = await post(
      uri,
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'theme': theme,
      }),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);

      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body) as List;
    return body.map((e) => InfluencerSummary.fromJson(e)).toList();
  }

  Future<List<InfluencerSummary>> searchInfluencersByFilters(InfluencerFilters filters) async {
    final uri = Uri.parse('$kEndpoint/company/search-influencers-by-filters');

    final response = await post(
      uri,
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'themes': filters.themes,
        'departments': filters.departments,
        'ages': filters.ages,
        'targets': filters.targets,
        'followers_range': filters.followersRange,
        'engagement_rate_range': filters.engagementRateRange,
      }),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);

      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body) as List;
    return body.map((e) => InfluencerSummary.fromJson(e)).toList();
  }

  Future<i.ProfileCompletionStatus> getInfluencerCompletionStatus(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-influencer-completion-status/$userId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return i.ProfileCompletionStatus.fromMap(body);
  }

  Future<Influencer> getInfluencer(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-influencer/$userId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return Influencer.fromMap(body);
  }

  Future<InstagramAccount> getInfluencerInstagramAccount(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-influencer-instagram-statistics/$userId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return InstagramAccount.fromMap(body);
  }
}
