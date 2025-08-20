import 'package:rociny/features/influencer/complete_profile/data/models/social_network_model.dart';

class Company {
  final int id;
  final int userId;
  String? profilePicture;
  String? name;
  String? department;
  String? description;
  DateTime createdAt;
  String? vatNumber;
  String? tradeName;
  String? city;
  String? street;
  String? postalCode;
  String? stripeCustomerId;
  List<SocialNetwork> socialNetworks;
  final int collaborationAmount;
  final double averageStars;

  Company({
    required this.id,
    required this.userId,
    this.profilePicture,
    this.name,
    this.department,
    this.description,
    this.vatNumber,
    this.postalCode,
    this.city,
    this.street,
    this.tradeName,
    this.stripeCustomerId,
    required this.createdAt,
    required this.socialNetworks,
    required this.collaborationAmount,
    required this.averageStars,
  });

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      profilePicture: map['profile_picture'],
      name: map['name'],
      tradeName: map['trade_name'],
      vatNumber: map['vat_number'],
      city: map['city'],
      street: map['street'],
      postalCode: map['postal_code'],
      department: map['department'],
      description: map['description'],
      stripeCustomerId: map['stripe_customer_id'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      socialNetworks: SocialNetwork.fromJsons(map['social_networks']),
      collaborationAmount: (map['collaboration_amount'] is String)
          ? int.tryParse(map['collaboration_amount']) ?? 0
          : (map['collaboration_amount'] ?? 0) as int,
      averageStars: (map['average_stars'] is String)
          ? double.tryParse(map['average_stars']) ?? 0.0
          : (map['average_stars'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String getBillingAddress() {
    if (street == null || city == null || postalCode == null) {
      return '';
    }
    return '$street, $city, $postalCode, France';
  }

  bool hasVATNumber() {
    return vatNumber != null;
  }
}
