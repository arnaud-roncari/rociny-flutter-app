class CollaboratedCompany {
  final int userId;
  final String name;
  final String? profilePicture;

  /// TODO FIX les routes et repo doc des controller back et front (demander suggestions et optimisation) (push avant)
  /// TODO faire pareil avec les routes du front (et deeplink insta, stripe)
  /// demander comme le back aurait orga le service colalb et conversations (selon serive inf et comp)
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
