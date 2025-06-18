import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';

class Company {
  final int id;
  final int userId;
  String? profilePicture;
  String? name;
  String? department;
  String? description;
  DateTime createdAt;
  List<SocialNetwork> socialNetworks;

  Company({
    required this.id,
    required this.userId,
    this.profilePicture,
    this.name,
    this.department,
    this.description,
    required this.createdAt,
    required this.socialNetworks,
  });

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      profilePicture: map['profile_picture'],
      name: map['name'],
      department: map['department'],
      description: map['description'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      socialNetworks: SocialNetwork.fromJsons(map['social_networks']),
    );
  }
}
