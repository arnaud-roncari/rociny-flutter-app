import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/collaborations/data/dto/supply_collaboration_dto.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';
import 'package:rociny/features/company/complete_profile/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/inlfuencer_filters.dart';
import 'package:rociny/features/company/search/data/models/review_model.dart';
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

  Future<Collaboration> createCollaboration(Collaboration collab) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/create-collaboration'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collab.toCreateJson()),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return Collaboration.fromJson(body);
  }

  Future<Collaboration> createDraftCollaboration(Collaboration collab) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/create-draft-collaboration'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(collab.toCreateJson()),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return Collaboration.fromJson(body);
  }

  Future<int> calculateProductPlacementPrice(int userId, ProductPlacementType productPlacement) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/calculate-product-placement-price/$userId/${productPlacement.name}'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return body['price'] as int;
  }

  Future<Collaboration> getCollaboration(int id) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-collaboration/$id'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return Collaboration.fromJson(body);
  }

  Future<List<Collaboration>> getCompanyCollaborations() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaborations'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => Collaboration.fromJson(e)).toList();
  }

  Future<List<String>> uploadCollaborationFiles(
    int collaborationId,
    List<File> files,
  ) async {
    final uri = Uri.parse('$kEndpoint/company/upload-collaboration-files/$collaborationId');
    final request = MultipartRequest('POST', uri)..headers['Authorization'] = 'Bearer $kJwt';

    for (final file in files) {
      request.files.add(await MultipartFile.fromPath('files', file.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(responseBody));
    }

    final body = jsonDecode(responseBody);
    return List<String>.from(body['files']);
  }

  Future<List<CollaborationSummary>> getCollaborationSummaries() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-collaboration-summaries'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return CollaborationSummary.fromJsons(body);
  }

  Future<void> cancelCollaboration(int collaborationid) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaboration/cancel/$collaborationid'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> sendDraftCollaboration(int collaborationid) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/send-draft-collaboration/$collaborationid'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<SupplyCollaborationDto> supplyCollaboration(int collaborationId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/supply-collaboration/$collaborationId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return SupplyCollaborationDto.fromJson(body);
  }

  Future<void> validateCollaboration(int collaborationId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/validate-collaboration/$collaborationId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> createReview(int collaborationId, int reviewedId, int stars, String description) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/create-review'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'collaboration_id': collaborationId,
        'reviewed_id': reviewedId,
        "stars": stars,
        "description": description,
      }),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<Review?> getReview(int collaborationId, int authorId, int reviewedId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-review/$collaborationId/$authorId/$reviewedId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    if (body["review"] == null) {
      return null;
    }
    return Review.fromJson(body["review"]);
  }

  Future<List<Review>> getReviewsByAuthor(int authorId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-reviews/author/$authorId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return Review.fromJsons(body);
  }

  Future<List<Review>> getReviewsByReviewed(int reviewedId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/get-reviews/reviewed/$reviewedId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return Review.fromJsons(body);
  }

  Future<void> updateVATNumber(String vatNumber) async {
    var response = await put(
      Uri.parse('$kEndpoint/company/update-vat-number'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'vat_number': vatNumber}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateTradeName(String tradeName) async {
    var response = await put(
      Uri.parse('$kEndpoint/company/update-trade-name'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'trade_name': tradeName}),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> updateBillingAddress(
    String city,
    String street,
    String postalCode,
  ) async {
    var response = await put(
      Uri.parse('$kEndpoint/company/update-billing-address'),
      headers: {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'city': city,
        'street': street,
        'postal_code': postalCode,
      }),
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }
}
