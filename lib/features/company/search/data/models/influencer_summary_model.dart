import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

class InfluencerSummary {
  final int id;
  final int userId;
  final String profilePicture;
  final List<String> portfolio;
  final String name;
  final int followers;

  InfluencerSummary({
    required this.id,
    required this.userId,
    required this.profilePicture,
    required this.portfolio,
    required this.name,
    required this.followers,
  });

  factory InfluencerSummary.fromJson(Map<String, dynamic> json) {
    return InfluencerSummary(
      id: json['id'],
      userId: json['user_id'],
      profilePicture: json['profile_picture'] as String,
      portfolio: List<String>.from(json['portfolio'] ?? []),
      name: json['name'] as String,
      followers: json['followers'] ?? 0,
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
    );
  }
}
