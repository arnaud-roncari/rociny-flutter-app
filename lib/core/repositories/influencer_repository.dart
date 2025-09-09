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
import 'package:rociny/features/company/settings/data/models/user_preference_model.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';
import 'package:rociny/features/influencer/conversation/data/models/conversation_model.dart';
import 'package:rociny/features/influencer/conversation/data/models/message_model.dart';
import 'package:rociny/features/influencer/dashboard/data/models/influencer_statistics_model.dart';
import 'package:rociny/features/influencer/profile/data/models/collaborated_company_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart' as c;

class InfluencerRepository {
  Map<String, String> _headers() => {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      };

  /// Upload or update profile picture
  Future<String> updateProfilePicture(File image) async {
    final request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/influencer/profile-picture'),
    )
      ..headers['Authorization'] = 'Bearer $kJwt'
      ..files.add(await MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final body = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return body["profile_picture"];
  }

  /// Replace the whole portfolio
  Future<List<String>> updatePortfolio(List<File> images) async {
    final request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/influencer/portfolio'),
    )..headers['Authorization'] = 'Bearer $kJwt';

    for (final img in images) {
      request.files.add(await MultipartFile.fromPath('files', img.path));
    }

    final response = await request.send();
    final body = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, body);
    }
    return List<String>.from(body["portfolio"]);
  }

  /// Add pictures to portfolio
  Future<void> addPicturesToPortfolio(List<File> images) async {
    final request = MultipartRequest(
      'POST',
      Uri.parse('$kEndpoint/influencer/portfolio/pictures'),
    )..headers['Authorization'] = 'Bearer $kJwt';

    for (final img in images) {
      request.files.add(await MultipartFile.fromPath('files', img.path));
    }

    final response = await request.send();

    if (response.statusCode >= 400) {
      final body = jsonDecode(await response.stream.bytesToString());
      throw ApiException.fromJson(response.statusCode, body);
    }
  }

  /// Remove picture from portfolio
  Future<void> removePictureFromPortfolio(String pictureUrl) async {
    final response = await delete(
      Uri.parse('$kEndpoint/influencer/portfolio/pictures/$pictureUrl'),
      headers: {'Authorization': 'Bearer $kJwt'},
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update influencer name
  Future<void> updateName(String name) async {
    final res =
        await put(Uri.parse('$kEndpoint/influencer/name'), headers: _headers(), body: jsonEncode({'name': name}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update VAT number
  Future<void> updateVATNumber(String vat) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/vat-number'),
        headers: _headers(), body: jsonEncode({'vat_number': vat}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update description
  Future<void> updateDescription(String desc) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/description'),
        headers: _headers(), body: jsonEncode({'description': desc}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update department
  Future<void> updateDepartment(String dep) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/department'),
        headers: _headers(), body: jsonEncode({'department': dep}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update themes
  Future<void> updateThemes(List<String> themes) async {
    final res =
        await put(Uri.parse('$kEndpoint/influencer/themes'), headers: _headers(), body: jsonEncode({'themes': themes}));

    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update target audiences
  Future<void> updateTargetAudiences(List<String> audiences) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/target-audience'),
        headers: _headers(), body: jsonEncode({'target_audience': audiences}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Add a social network
  Future<void> addSocialNetwork(PlatformType platform, String url) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/social-networks'),
        headers: _headers(), body: jsonEncode({'platform': platform.name, 'url': url}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get all social networks
  Future<List<SocialNetwork>> getSocialNetworks() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/social-networks'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return SocialNetwork.fromJsons(jsonDecode(res.body));
  }

  /// Delete a social network
  Future<void> deleteSocialNetwork(int id) async {
    final res = await delete(Uri.parse('$kEndpoint/influencer/social-networks/$id'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Update a social network
  Future<void> updateSocialNetwork(int id, String url) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/social-networks/$id'),
        headers: _headers(), body: jsonEncode({'url': url}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Add a legal document
  Future<void> addLegalDocument(LegalDocumentType type, File file) async {
    final request = MultipartRequest(
      'POST',
      Uri.parse('$kEndpoint/influencer/legal-documents/${type.name}'),
    )
      ..headers['Authorization'] = 'Bearer $kJwt'
      ..files.add(await MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(await response.stream.bytesToString()));
    }
  }

  /// Get status of a legal document
  Future<LegalDocumentStatus> getLegalDocumentStatus(LegalDocumentType type) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/legal-documents/${type.name}/status'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    final s = jsonDecode(res.body)['status'];
    return LegalDocumentStatus.values.firstWhere((e) => e.name == s);
  }

  /// Delete a legal document
  Future<void> deleteLegalDocument(LegalDocumentType type) async {
    final res = await delete(Uri.parse('$kEndpoint/influencer/legal-documents/${type.name}'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get Stripe account onboarding URL
  Future<String> getStripeAccountUrl() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/payments/account-link'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return jsonDecode(res.body)['url'];
  }

  /// Get Stripe login link
  Future<String> getStripeLoginUrl() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/payments/login-link'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return jsonDecode(res.body)['url'];
  }

  /// Check if influencer has completed legal documents
  Future<bool> hasCompletedLegalDocuments() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/legal-documents/completed'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return jsonDecode(res.body)['has_completed'];
  }

  /// Check if influencer has completed Stripe onboarding
  Future<bool> hasCompletedStripe() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/payments/completed'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return jsonDecode(res.body)['has_completed'];
  }

  /// Check if influencer has linked Instagram
  Future<bool> hasInstagramAccount() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/social/instagram/has-account'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return jsonDecode(res.body)['has_instagram_account'];
  }

  /// Get Instagram account
  Future<InstagramAccount> getInstagramAccount() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/social/instagram'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return InstagramAccount.fromMap(jsonDecode(res.body));
  }

  /// Link a fetched Instagram account
  Future<void> createInstagramAccount(String fetchedId) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/social/instagram/$fetchedId'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get authenticated influencer details
  Future<Influencer> getInfluencer() async {
    final res = await get(Uri.parse('$kEndpoint/influencer'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Influencer.fromMap(jsonDecode(res.body));
  }

  /// Get influencer profile completion status
  Future<ProfileCompletionStatus> getProfileCompletionStatus() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/profile/completion-status'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return ProfileCompletionStatus.fromMap(jsonDecode(res.body));
  }

  /// Get collaboration summaries
  Future<List<CollaborationSummary>> getCollaborationSummaries() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/collaborations/summaries'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return CollaborationSummary.fromJsons(jsonDecode(res.body));
  }

  /// Accept collaboration
  Future<void> acceptCollaboration(int id) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/collaborations/$id/accept'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Refuse collaboration
  Future<void> refuseCollaboration(int id) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/collaborations/$id/refuse'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// End collaboration
  Future<void> endCollaboration(int id) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/collaborations/$id/end'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get collaboration by ID
  Future<Collaboration> getCollaboration(int id) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/collaborations/$id'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Collaboration.fromJson(jsonDecode(res.body));
  }

  /// Create a review
  Future<void> createReview(int collabId, int reviewedId, int stars, String description) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/reviews'),
        headers: _headers(),
        body: jsonEncode({
          'collaboration_id': collabId,
          'reviewed_id': reviewedId,
          'stars': stars,
          'description': description,
        }));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get a specific review
  Future<Review?> getReview(int collabId, int authorId, int reviewedId) async {
    final res =
        await get(Uri.parse('$kEndpoint/influencer/reviews/$collabId/$authorId/$reviewedId'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    final body = jsonDecode(res.body);
    return body["review"] == null ? null : Review.fromJson(body["review"]);
  }

  /// Get reviews by author
  Future<List<Review>> getReviewsByAuthor(int authorId) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/reviews/author/$authorId'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Review.fromJsons(jsonDecode(res.body));
  }

  /// Get reviews by reviewed
  Future<List<Review>> getReviewsByReviewed(int reviewedId) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/reviews/reviewed/$reviewedId'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Review.fromJsons(jsonDecode(res.body));
  }

  /// Get review summaries
  Future<List<ReviewSummary>> getReviewSummaries() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/reviews/summaries'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return ReviewSummary.fromJsons(jsonDecode(res.body));
  }

  /// Get company details
  Future<Company> getCompany(int userId) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/companies/$userId'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Company.fromMap(jsonDecode(res.body));
  }

  /// Get company profile completion status
  Future<c.ProfileCompletionStatus> getCompanyCompletionStatus(int userId) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/companies/$userId/completion-status'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return c.ProfileCompletionStatus.fromMap(jsonDecode(res.body));
  }

  /// Get company Instagram statistics
  Future<InstagramAccount> getCompanyInstagramAccount(int userId) async {
    final res =
        await get(Uri.parse('$kEndpoint/influencer/companies/$userId/instagram-statistics'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return InstagramAccount.fromMap(jsonDecode(res.body));
  }

  /// Get companies the influencer has collaborated with
  Future<List<CollaboratedCompany>> getCollaboratedCompanies() async {
    final res =
        await get(Uri.parse('$kEndpoint/influencer/collaborations/collaborated-companies'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return CollaboratedCompany.fromJsons(jsonDecode(res.body));
  }

  /// Get influencers a company has collaborated with
  Future<List<InfluencerSummary>> getCompanyCollaboratedInfluencers(int userId) async {
    final res =
        await get(Uri.parse('$kEndpoint/influencer/companies/$userId/collaborated-influencers'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return InfluencerSummary.fromJsons(jsonDecode(res.body));
  }

  /// Get dashboard statistics
  Future<InfluencerStatistics> getStatistics() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/dashboard/statistics'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return InfluencerStatistics.fromJson(jsonDecode(res.body));
  }

  /// Get recent collaborations from dashboard
  Future<List<CollaborationSummary>> getRecentCollaborations() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/dashboard/collaborations'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return CollaborationSummary.fromJsons(jsonDecode(res.body));
  }

  /// Get all conversations
  Future<List<ConversationSummary>> getAllConversations() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/conversations'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return ConversationSummary.fromJsons(jsonDecode(res.body));
  }

  /// Get messages by conversation
  Future<List<Message>> getMessagesByConversation(int id) async {
    final res = await get(Uri.parse('$kEndpoint/influencer/conversations/$id/messages'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return Message.fromJsons(jsonDecode(res.body));
  }

  /// Mark all messages of a conversation as read
  Future<void> markConversationMessagesAsRead(int id) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/conversations/$id/mark-as-read'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Add a message to conversation
  Future<void> addMessage(int conversationId, String content) async {
    final res = await post(Uri.parse('$kEndpoint/influencer/conversations/$conversationId/messages'),
        headers: _headers(), body: jsonEncode({'conversation_id': conversationId, 'content': content}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }

  /// Get user notification preferences
  Future<List<UserNotificationPreference>> getUserPreferences() async {
    final res = await get(Uri.parse('$kEndpoint/influencer/notifications/preferences'), headers: _headers());
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
    return UserNotificationPreference.fromJsonList(jsonDecode(res.body));
  }

  /// Update user notification preference
  Future<void> updatePreference(String type, bool enabled) async {
    final res = await put(Uri.parse('$kEndpoint/influencer/notifications/preferences'),
        headers: _headers(), body: jsonEncode({'type': type, 'enabled': enabled}));
    if (res.statusCode >= 400) {
      throw ApiException.fromJson(res.statusCode, jsonDecode(res.body));
    }
  }
}
