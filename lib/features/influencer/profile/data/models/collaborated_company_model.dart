class CollaboratedCompany {
  final int userId;
  final String name;
  final String? profilePicture;

  CollaboratedCompany({
    required this.userId,
    required this.name,
    this.profilePicture,
  });

  factory CollaboratedCompany.fromJson(Map<String, dynamic> json) {
    return CollaboratedCompany(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'profile_picture': profilePicture,
    };
  }

  static List<CollaboratedCompany> fromJsons(List<dynamic> jsons) {
    return jsons.map((e) => CollaboratedCompany.fromJson(e as Map<String, dynamic>)).toList();
  }
}
