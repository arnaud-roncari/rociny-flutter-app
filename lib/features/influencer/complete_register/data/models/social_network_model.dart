import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';

PlatformType platformTypeFromString(String value) {
  return PlatformType.values.firstWhere(
    (e) => e.name == value,
  );
}

class SocialNetwork {
  final int id;
  final PlatformType platform;
  final String url;

  SocialNetwork({
    required this.id,
    required this.platform,
    required this.url,
  });

  factory SocialNetwork.fromJson(Map<String, dynamic> json) {
    return SocialNetwork(
      id: json['id'],
      platform: platformTypeFromString(json['platform']),
      url: json['url'],
    );
  }

  static List<SocialNetwork> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((json) => SocialNetwork.fromJson(json)).toList();
  }
}
