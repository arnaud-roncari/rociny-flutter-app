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
      socialNetworks: SocialNetwork.fromJsons(map['social_networks']),
    );
  }
}
