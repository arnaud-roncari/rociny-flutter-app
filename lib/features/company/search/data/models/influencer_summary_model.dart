import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

class InfluencerSummary {
  final int id;
  final int userId;
  final String profilePicture;
  final List<String> portfolio;
  final String name;
  final int followers;
  final double averageStars;
  final int collaborationsAmount;

  InfluencerSummary({
    required this.id,
    required this.userId,
    required this.profilePicture,
    required this.portfolio,
    required this.name,
    required this.followers,
    required this.averageStars,
    required this.collaborationsAmount,
  });

  factory InfluencerSummary.fromJson(Map<String, dynamic> json) {
    return InfluencerSummary(
      id: json['id'],
      userId: json['user_id'],
      profilePicture: json['profile_picture'] as String,
      portfolio: List<String>.from(json['portfolio'] ?? []),
      name: json['name'] as String,
      followers: (json['followers'] is String)
          ? int.tryParse(json['followers']) ?? 0
          : (json['followers'] ?? json['followers_count'] ?? 0) as int,
      collaborationsAmount: (json['collaboration_amount'] is String)
          ? int.tryParse(json['collaboration_amount']) ?? 0
          : (json['collaboration_amount'] ?? 0) as int,
      averageStars: (json['average_stars'] is int)
          ? (json['average_stars'] as int).toDouble()
          : (json['average_stars'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_picture': profilePicture,
      'portfolio': portfolio,
      'name': name,
      'followers': followers,
    };
  }

  String getFollowers() {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(followers % 1000000 == 0 ? 0 : 1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(followers % 1000 == 0 ? 0 : 1)}K';
    } else {
      return followers.toString();
    }
  }

  factory InfluencerSummary.fromInfluencer(
    Influencer influencer,
    InstagramAccount instagramAccount,
  ) {
    final int followerCount = instagramAccount.followersCount ?? 0;

    return InfluencerSummary(
      id: influencer.id,
      userId: influencer.userId,
      profilePicture: influencer.profilePicture!,
      portfolio: influencer.portfolio,
      name: influencer.name!,
      followers: followerCount,
      collaborationsAmount: influencer.collaborationAmount,
      averageStars: influencer.averageStars,
    );
  }

  static List<InfluencerSummary> fromJsons(List<dynamic> jsons) {
    return jsons.map((e) => InfluencerSummary.fromJson(e as Map<String, dynamic>)).toList();
  }
}
