import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';

class Influencer {
  final int id;
  final int userId;
  String? profilePicture;
  List<String> portfolio;
  String? name;
  String? department;
  String? description;
  List<String> themes;
  List<String> targetAudience;
  DateTime createdAt;
  String? vatNumber;
  List<SocialNetwork> socialNetworks;
  final int collaborationAmount;
  final double averageStars;

  Influencer({
    required this.id,
    required this.userId,
    this.profilePicture,
    this.portfolio = const [],
    this.name,
    this.department,
    this.description,
    this.vatNumber,
    this.themes = const [],
    this.targetAudience = const [],
    required this.createdAt,
    required this.socialNetworks,
    required this.collaborationAmount,
    required this.averageStars,
  });

  factory Influencer.fromMap(Map<String, dynamic> map) {
    return Influencer(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      vatNumber: map['vat_number'],
      profilePicture: map['profile_picture'],
      portfolio: List<String>.from(map['portfolio'] ?? []),
      name: map['name'],
      department: map['department'],
      description: map['description'],
      themes: List<String>.from(map['themes'] ?? []),
      targetAudience: List<String>.from(map['target_audience'] ?? []),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      socialNetworks: SocialNetwork.fromJsons(map['social_networks'] ?? []),
      collaborationAmount: (map['collaboration_amount'] is String)
          ? int.tryParse(map['collaboration_amount']) ?? 0
          : (map['collaboration_amount'] ?? 0) as int,
      averageStars: (map['average_stars'] is String)
          ? double.tryParse(map['average_stars']) ?? 0.0
          : (map['average_stars'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bool hasVATNumber() {
    return vatNumber != null;
  }
}
