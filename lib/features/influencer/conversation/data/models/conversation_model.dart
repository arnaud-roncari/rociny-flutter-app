import 'package:intl/intl.dart';

class ConversationSummary {
  int id;
  int influencerId;
  int companyId;
  DateTime createdAt;
  DateTime updatedAt;

  String? lastMessage;
  int companyUnreadMessageCount;
  int influencerUnreadMessageCount;

  String companyName;
  String? companyProfilePicture;
  String influencerName;
  String? influencerProfilePicture;

  ConversationSummary({
    required this.id,
    required this.influencerId,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.companyUnreadMessageCount,
    required this.influencerUnreadMessageCount,
    required this.companyName,
    required this.companyProfilePicture,
    required this.influencerName,
    required this.influencerProfilePicture,
  });

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      id: json['id'],
      influencerId: json['influencer_id'],
      companyId: json['company_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastMessage: json['last_message'],
      companyUnreadMessageCount: json['company_unread_message_count'] ?? 0,
      influencerUnreadMessageCount: json['influencer_unread_message_count'] ?? 0,
      companyName: json['company_name'],
      companyProfilePicture: json['company_profile_picture'],
      influencerName: json['influencer_name'],
      influencerProfilePicture: json['influencer_profile_picture'],
    );
  }

  static List<ConversationSummary> fromJsons(List<dynamic> jsons) {
    return jsons.map((json) => ConversationSummary.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'influencer_id': influencerId,
      'company_id': companyId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_message': lastMessage,
      'company_unread_message_count': companyUnreadMessageCount,
      'influencer_unread_message_count': influencerUnreadMessageCount,
      'company_name': companyName,
      'company_profile_picture': companyProfilePicture,
      'influencer_name': influencerName,
      'influencer_profile_picture': influencerProfilePicture,
    };
  }

  String getTime() {
    return DateFormat.Hm().format(updatedAt);
  }

  void refresh(ConversationSummary summary) {
    id = summary.id;
    influencerId = summary.influencerId;
    companyId = summary.companyId;
    createdAt = summary.createdAt;
    updatedAt = summary.updatedAt;
    lastMessage = summary.lastMessage;
    companyUnreadMessageCount = summary.companyUnreadMessageCount;
    influencerUnreadMessageCount = summary.influencerUnreadMessageCount;
    companyName = summary.companyName;
    companyProfilePicture = summary.companyProfilePicture;
    influencerName = summary.influencerName;
    influencerProfilePicture = summary.influencerProfilePicture;
  }
}
