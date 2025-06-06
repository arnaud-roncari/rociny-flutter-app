class InstagramAccount {
  final int id;
  final String instagramId;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final int? followersCount;

  InstagramAccount({
    required this.id,
    required this.instagramId,
    required this.name,
    required this.username,
    this.profilePictureUrl,
    this.followersCount,
  });

  factory InstagramAccount.fromMap(Map<String, dynamic> json) {
    return InstagramAccount(
      id: json['id'],
      instagramId: json['instagram_id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      followersCount: json['followers_count'] is num ? (json['followers_count'] as num).toInt() : null,
    );
  }

  static List<InstagramAccount> fromMaps(List<dynamic> jsonList) {
    return jsonList.map((json) => InstagramAccount.fromMap(json as Map<String, dynamic>)).toList();
  }
}
