import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';

class CollaborationSummary {
  final int userId;
  final int collaborationId;
  final String influencerName;
  final String? influencerProfilePicture;
  final String collaborationTitle;
  final double collaborationPrice;
  final CollaborationStatus collaborationStatus;
  final int placementsCount;

  CollaborationSummary({
    required this.userId,
    required this.collaborationId,
    required this.influencerName,
    this.influencerProfilePicture,
    required this.collaborationTitle,
    required this.collaborationPrice,
    required this.collaborationStatus,
    required this.placementsCount,
  });

  factory CollaborationSummary.fromJson(Map<String, dynamic> json) {
    return CollaborationSummary(
      userId: json['user_id'] ?? 0,
      collaborationId: json['collaboration_id'] ?? 0,
      influencerName: json['influencer_name'] ?? '',
      influencerProfilePicture: json['influencer_profile_picture'],
      collaborationTitle: json['collaboration_title'] ?? '',
      collaborationPrice: (json['collaboration_price'] ?? 0).toDouble(),
      collaborationStatus: CollaborationStatus.fromString(json['collaboration_status'] ?? "draft"),
      placementsCount: json['placements_count'] ?? 0,
    );
  }

  String getPrice() {
    return collaborationPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'influencer_name': influencerName,
      'influencer_profile_picture': influencerProfilePicture,
      'collaboration_title': collaborationTitle,
      'collaboration_price': collaborationPrice,
      'collaboration_status': collaborationStatus,
      'placements_count': placementsCount,
    };
  }

  static List<CollaborationSummary> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((json) => CollaborationSummary.fromJson(json as Map<String, dynamic>)).toList();
  }
}
