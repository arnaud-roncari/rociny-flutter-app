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
import 'package:rociny/features/company/search/data/models/inlfuencer_filters.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart' as i;
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
import 'package:rociny/features/influencer/profile/data/models/collaborated_company_model.dart';

class CompanyRepository {
  Map<String, String> _headers() => {
        'Authorization': 'Bearer $kJwt',
        'Content-Type': 'application/json',
      };

  /// Upload or update company profile picture
  Future<String> updateProfilePicture(File image) async {
    var request = MultipartRequest(
      'PUT',
      Uri.parse('$kEndpoint/company/profile-picture'),
    );
    request.files.add(await MultipartFile.fromPath('file', image.path));
    request.headers['Authorization'] = 'Bearer $kJwt';

    final response = await request.send();
    final bodyString = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(bodyString));
    }
    return jsonDecode(bodyString)["profile_picture"];
  }

  /// Update company name
  Future<void> updateName(String name) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/name'),
      headers: _headers(),
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update company description
  Future<void> updateDescription(String description) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/description'),
      headers: _headers(),
      body: jsonEncode({'description': description}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update company department
  Future<void> updateDepartment(String department) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/department'),
      headers: _headers(),
      body: jsonEncode({'department': department}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update trade name
  Future<void> updateTradeName(String tradeName) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/trade-name'),
      headers: _headers(),
      body: jsonEncode({'trade_name': tradeName}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update VAT number
  Future<void> updateVATNumber(String vatNumber) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/vat-number'),
      headers: _headers(),
      body: jsonEncode({'vat_number': vatNumber}),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Update billing address
  Future<void> updateBillingAddress(String city, String street, String postalCode) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/billing-address'),
      headers: _headers(),
      body: jsonEncode({
        'city': city,
        'street': street,
        'postal_code': postalCode,
      }),
    );
    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Add a social network to company profile
  Future<void> addSocialNetwork(PlatformType platform, String url) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/social-networks'),
      headers: _headers(),
      body: jsonEncode({
        'platform': platform.name,
        "url": url,
      }),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }
  }

  /// Get all social networks for the company
  Future<List<SocialNetwork>> getSocialNetworks() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/social-networks'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    final List<dynamic> body = jsonDecode(response.body);
    return SocialNetwork.fromJsons(body);
  }

  /// Delete a social network by ID
  Future<void> deleteSocialNetwork(int id) async {
    final response = await delete(
      Uri.parse('$kEndpoint/company/social-networks/$id'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }
  }

  /// Update a social network by ID
  Future<void> updateSocialNetwork(int id, String url) async {
    final response = await put(
      Uri.parse('$kEndpoint/company/social-networks/$id'),
      headers: _headers(),
      body: jsonEncode({
        "url": url,
      }),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Add a new legal document
  Future<void> addLegalDocument(LegalDocumentType type, File file) async {
    final uri = Uri.parse('$kEndpoint/company/legal-documents/${type.name}');
    final request = MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $kJwt'
      ..files.add(await MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final bodyString = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(bodyString));
    }
  }

  /// Get status of a specific legal document
  Future<LegalDocumentStatus> getLegalDocumentStatus(LegalDocumentType type) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/legal-documents/${type.name}/status'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final String s = jsonDecode(response.body)['status'];
    return LegalDocumentStatus.values.firstWhere((e) => e.name == s);
  }

  /// Delete a legal document
  Future<void> deleteLegalDocument(LegalDocumentType type) async {
    final response = await delete(
      Uri.parse('$kEndpoint/company/legal-documents/${type.name}'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Check if company has completed all legal documents
  Future<bool> hasCompletedLegalDocuments() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/legal-documents/completed'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return jsonDecode(response.body)['has_completed'];
  }

  /// Create a new Stripe SetupIntent
  Future<SetupIntentDto> createSetupIntent() async {
    final response = await post(
      Uri.parse('$kEndpoint/company/payments/setup-intent'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return SetupIntentDto.fromJson(jsonDecode(response.body));
  }

  /// Check if Stripe onboarding is completed
  Future<bool> hasCompletedStripe() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/payments/completed'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return jsonDecode(response.body)['has_completed'];
  }

  /// Get Stripe billing portal session link
  Future<String> getBillingPortalSession() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/payments/billing-portal'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return jsonDecode(response.body)['url'];
  }

  /// Check if company has an Instagram account linked
  Future<bool> hasInstagramAccount() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/social/instagram/has-account'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    return jsonDecode(response.body)['has_instagram_account'];
  }

  /// Get Instagram account details of company
  Future<InstagramAccount> getInstagramAccount() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/social/instagram'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    return InstagramAccount.fromMap(jsonDecode(response.body));
  }

  /// Link a fetched Instagram account to company
  Future<void> createInstagramAccount(String fetchedInstagramAccountId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/social/instagram/$fetchedInstagramAccountId'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }
  }

  /// Get company profile completion status
  Future<ProfileCompletionStatus> getProfileCompletionStatus() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/profile/completion-status'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    return ProfileCompletionStatus.fromMap(jsonDecode(response.body));
  }

  /// Check if company profile is completed
  Future<bool> hasCompletedProfile() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/profile/completed'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    return jsonDecode(response.body)['has_completed_profile'];
  }

  /// Get authenticated company details
  Future<Company> getCompany() async {
    final response = await get(
      Uri.parse('$kEndpoint/company'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(
        response.statusCode,
        jsonDecode(response.body),
      );
    }

    return Company.fromMap(jsonDecode(response.body));
  }

  /// Create a new collaboration
  Future<Collaboration> createCollaboration(Collaboration collab) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations'),
      headers: _headers(),
      body: jsonEncode(collab.toCreateJson()),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Collaboration.fromJson(jsonDecode(response.body));
  }

  /// Create a draft collaboration
  Future<Collaboration> createDraftCollaboration(Collaboration collab) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations/drafts'),
      headers: _headers(),
      body: jsonEncode(collab.toCreateJson()),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Collaboration.fromJson(jsonDecode(response.body));
  }

  /// Get collaboration by ID
  Future<Collaboration> getCollaboration(int id) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaborations/$id'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Collaboration.fromJson(jsonDecode(response.body));
  }

  /// Get all collaborations of the company
  Future<List<Collaboration>> getCompanyCollaborations() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaborations'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => Collaboration.fromJson(e)).toList();
  }

  /// Get collaboration summaries
  Future<List<CollaborationSummary>> getCollaborationSummaries() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaborations/summaries'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return CollaborationSummary.fromJsons(jsonDecode(response.body));
  }

  /// Upload collaboration files
  Future<List<String>> uploadCollaborationFiles(
    int collaborationId,
    List<File> files,
  ) async {
    final uri = Uri.parse('$kEndpoint/company/collaborations/$collaborationId/files');
    final request = MultipartRequest('POST', uri)..headers['Authorization'] = 'Bearer $kJwt';

    for (final file in files) {
      request.files.add(await MultipartFile.fromPath('files', file.path));
    }

    final response = await request.send();
    final bodyString = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(bodyString));
    }

    return List<String>.from(jsonDecode(bodyString)['files']);
  }

  /// Cancel a collaboration
  Future<void> cancelCollaboration(int collaborationId) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations/$collaborationId/cancel'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Send a draft collaboration
  Future<void> sendDraftCollaboration(int collaborationId) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations/$collaborationId/send-draft'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Supply a collaboration (create payment intent)
  Future<SupplyCollaborationDto> supplyCollaboration(int collaborationId) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations/$collaborationId/supply'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return SupplyCollaborationDto.fromJson(jsonDecode(response.body));
  }

  /// Validate a collaboration
  Future<void> validateCollaboration(int collaborationId) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/collaborations/$collaborationId/validate'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Create a review for a collaboration
  Future<void> createReview(int collaborationId, int reviewedId, int stars, String description) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/reviews'),
      headers: _headers(),
      body: jsonEncode({
        'collaboration_id': collaborationId,
        'reviewed_id': reviewedId,
        "stars": stars,
        "description": description,
      }),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Get a specific review
  Future<Review?> getReview(int collaborationId, int authorId, int reviewedId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/reviews/$collaborationId/$authorId/$reviewedId'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final body = jsonDecode(response.body);
    if (body["review"] == null) return null;
    return Review.fromJson(body["review"]);
  }

  /// Get reviews written by a specific author
  Future<List<Review>> getReviewsByAuthor(int authorId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/reviews/author/$authorId'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Review.fromJsons(jsonDecode(response.body));
  }

  /// Get reviews received by a specific user
  Future<List<Review>> getReviewsByReviewed(int reviewedId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/reviews/reviewed/$reviewedId'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Review.fromJsons(jsonDecode(response.body));
  }

  /// Get review summaries for the company
  Future<List<ReviewSummary>> getReviewSummaries() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/reviews/summaries'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return ReviewSummary.fromJsons(jsonDecode(response.body));
  }

  /// Get review summaries for an influencer
  Future<List<ReviewSummary>> getInfluencerReviewSummaries(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId/review-summaries'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return ReviewSummary.fromJsons(jsonDecode(response.body));
  }

  /// Search influencers by theme
  Future<List<InfluencerSummary>> searchInfluencersByTheme({String? theme}) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/influencers/search-by-theme'),
      headers: _headers(),
      body: jsonEncode({'theme': theme}),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => InfluencerSummary.fromJson(e)).toList();
  }

  /// Search influencers by filters
  Future<List<InfluencerSummary>> searchInfluencersByFilters(InfluencerFilters filters) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/influencers/search-by-filters'),
      headers: _headers(),
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
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((e) => InfluencerSummary.fromJson(e)).toList();
  }

  /// Get detailed influencer profile
  Future<Influencer> getInfluencer(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Influencer.fromMap(jsonDecode(response.body));
  }

  /// Get influencer Instagram statistics
  Future<InstagramAccount> getInfluencerInstagramAccount(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId/instagram-statistics'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return InstagramAccount.fromMap(jsonDecode(response.body));
  }

  /// Calculate product placement price
  Future<int> calculateProductPlacementPrice(int userId, ProductPlacementType type) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId/product-placement-price/${type.name}'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return jsonDecode(response.body)['price'] as int;
  }

  /// Get influencer profile completion status
  Future<i.ProfileCompletionStatus> getInfluencerCompletionStatus(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId/completion-status'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return i.ProfileCompletionStatus.fromMap(jsonDecode(response.body));
  }

  /// Get companies an influencer has collaborated with
  Future<List<CollaboratedCompany>> getInfluencerCollaboratedCompanies(int userId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/influencers/$userId/collaborated-companies'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return CollaboratedCompany.fromJsons(jsonDecode(response.body));
  }

  /// Get influencers the company has collaborated with
  Future<List<InfluencerSummary>> getCollaboratedInfluencers() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/collaborations/collaborated-influencers'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return InfluencerSummary.fromJsons(jsonDecode(response.body));
  }

  /// Get all conversations of the company
  Future<List<ConversationSummary>> getAllConversations() async {
    final response = await get(
      Uri.parse('$kEndpoint/company/conversations'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return ConversationSummary.fromJsons(jsonDecode(response.body));
  }

  /// Get messages of a conversation
  Future<List<Message>> getMessagesByConversation(int conversationId) async {
    final response = await get(
      Uri.parse('$kEndpoint/company/conversations/$conversationId/messages'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    return Message.fromJsons(jsonDecode(response.body));
  }

  /// Mark all messages of a conversation as read
  Future<void> markConversationMessagesAsRead(int conversationId) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/conversations/$conversationId/mark-as-read'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Add a message to a conversation
  Future<void> addMessage(int conversationId, String content) async {
    final response = await post(
      Uri.parse('$kEndpoint/company/conversations/$conversationId/messages'),
      headers: _headers(),
      body: jsonEncode({
        "conversation_id": conversationId,
        "content": content,
      }),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }

  /// Get user notification preferences
  Future<List<UserNotificationPreference>> getUserPreferences() async {
    final response = await get(
      Uri.parse("$kEndpoint/company/notifications/preferences"),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }

    final List<dynamic> body = jsonDecode(response.body);
    return UserNotificationPreference.fromJsonList(body);
  }

  /// Update a specific notification preference
  Future<void> updatePreference(String type, bool enabled) async {
    final response = await put(
      Uri.parse("$kEndpoint/company/notifications/preferences"),
      headers: _headers(),
      body: jsonEncode({
        "type": type,
        "enabled": enabled,
      }),
    );

    if (response.statusCode >= 400) {
      throw ApiException.fromJson(response.statusCode, jsonDecode(response.body));
    }
  }
}
