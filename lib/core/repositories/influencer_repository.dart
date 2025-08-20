import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/review_summary.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/review_model.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';
import 'package:rociny/features/influencer/dashboard/data/models/influencer_statistics_model.dart';
import 'package:rociny/features/influencer/profile/data/models/collaborated_company_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart' as c;

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

  Future<void> addPicturesToPortfolio(List<File> images) async {
    var request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/influencer/add-pictures-to-portfolio'),
    );

    for (var image in images) {
      request.files.add(
        await MultipartFile.fromPath('files', image.path),
      );
    }

    request.headers['Authorization'] = 'Bearer $kJwt';

    StreamedResponse response = await request.send();

    if (response.statusCode >= 400) {
      String stringifiedBody = await response.stream.bytesToString();
      Map<String, dynamic> body = jsonDecode(stringifiedBody);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> removePictureFromPortfolio(String pictureUrl) async {
    var response = await delete(
      Uri.parse('$kEndpoint/influencer/remove-picture-from-portfolio/$pictureUrl'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
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

  Future<void> updateVATNumber(String vatNumber) async {
    var response = await put(
      Uri.parse('$kEndpoint/influencer/update-vat-number'),
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

  Future<Influencer> getInfluencer() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer'),
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

  Future<Company> getCompany(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-company/$userId'),
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

  Future<ProfileCompletionStatus> getProfileCompletionStatus() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-profile-completion-status'),
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

  Future<List<CollaborationSummary>> getCollaborationSummaries() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-collaboration-summaries'),
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

  Future<void> acceptCollaboration(int collaborationid) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/accept-collaboration/$collaborationid'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> refuseCollaboration(int collaborationid) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/refuse-collaboration/$collaborationid'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  Future<void> endCollaboration(int collaborationid) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/end-collaboration/$collaborationid'),
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
      Uri.parse('$kEndpoint/influencer/create-review'),
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
      Uri.parse('$kEndpoint/influencer/get-review/$collaborationId/$authorId/$reviewedId'),
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
      Uri.parse('$kEndpoint/influencer/get-reviews/author/$authorId'),
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
      Uri.parse('$kEndpoint/influencer/get-reviews/reviewed/$reviewedId'),
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

  Future<Collaboration> getCollaboration(int id) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-collaboration/$id'),
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

  Future<c.ProfileCompletionStatus> getCompanyCompletionStatus(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-company-completion-status/$userId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return c.ProfileCompletionStatus.fromMap(body);
  }

  Future<InstagramAccount> getCompanyInstagramAccount(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-company-instagram-statistics/$userId'),
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

  Future<List<ReviewSummary>> getReviewSummaries() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-review-summaries'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return ReviewSummary.fromJsons(body);
  }

  Future<List<CollaboratedCompany>> getCollaboratedCompanies() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-collaborated-companies'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return CollaboratedCompany.fromJsons(body);
  }

  Future<List<InfluencerSummary>> getCompanyCollaboratedInfluencers(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-company-collaborated-influencers/$userId'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    final body = jsonDecode(response.body);
    return InfluencerSummary.fromJsons(body);
  }

  Future<InfluencerStatistics> getStatistics() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-dashboard/statistics'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );
    print(response.body);
    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }

    final body = jsonDecode(response.body);
    return InfluencerStatistics.fromJson(body);
  }

  Future<List<CollaborationSummary>> getRecentCollaborations() async {
    final response = await get(
      Uri.parse('$kEndpoint/influencer/get-dashboard/collaborations'),
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
}
