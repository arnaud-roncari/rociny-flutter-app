/// Instagram account fetched from the facebook API.
class FetchedInstagramAccount {
  final String id;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final int? followersCount;

  FetchedInstagramAccount({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl,
    this.followersCount,
  });

  factory FetchedInstagramAccount.fromMap(Map<String, dynamic> json) {
    return FetchedInstagramAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      followersCount: json['followers_count'] is num ? (json['followers_count'] as num).toInt() : null,
    );
  }

  static List<FetchedInstagramAccount> fromMaps(List<dynamic> jsonList) {
    return jsonList.map((json) => FetchedInstagramAccount.fromMap(json as Map<String, dynamic>)).toList();
  }
}
