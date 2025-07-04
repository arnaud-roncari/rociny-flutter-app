class InstagramAccount {
  final int id;
  final String instagramId;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final int? followersCount;
  final int? reach;
  final int? views;
  final int? profileViews;
  final double? profileViewRate;
  final int? websiteClicks;
  final int? linkClicks;
  final double? engagementRate;
  final int? totalInteractions;
  final double? interactionPercentagePosts;
  final double? interactionPercentageReels;
  final double? postPercentage;
  final double? reelPercentage;
  final double? genderMalePercentage;
  final double? genderFemalePercentage;
  final List<String>? topCities;
  final List<String>? topAgeRanges;
  final String? lastMediaUrl;

  InstagramAccount({
    required this.id,
    required this.instagramId,
    required this.name,
    required this.username,
    this.profilePictureUrl,
    this.followersCount,
    this.reach,
    this.views,
    this.profileViews,
    this.profileViewRate,
    this.websiteClicks,
    this.linkClicks,
    this.engagementRate,
    this.totalInteractions,
    this.interactionPercentagePosts,
    this.interactionPercentageReels,
    this.postPercentage,
    this.reelPercentage,
    this.genderMalePercentage,
    this.genderFemalePercentage,
    this.topCities,
    this.topAgeRanges,
    this.lastMediaUrl,
  });

  factory InstagramAccount.fromMap(Map<String, dynamic> json) {
    return InstagramAccount(
      id: json['id'] as int,
      instagramId: json['instagram_id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      followersCount: (json['followers_count'] is num) ? (json['followers_count'] as num).toInt() : null,
      reach: (json['reach'] is num) ? (json['reach'] as num).toInt() : null,
      views: (json['views'] is num) ? (json['views'] as num).toInt() : null,
      profileViews: (json['profile_views'] is num) ? (json['profile_views'] as num).toInt() : null,
      profileViewRate: (json['profile_view_rate'] as num?)?.toDouble(),
      websiteClicks: (json['website_clicks'] as num?)?.toInt(),
      linkClicks: (json['link_clicks'] as num?)?.toInt(),
      engagementRate: (json['engagement_rate'] as num?)?.toDouble(),
      totalInteractions: (json['total_interactions'] as num?)?.toInt(),
      interactionPercentagePosts: (json['interaction_percentage_posts'] as num?)?.toDouble(),
      interactionPercentageReels: (json['interaction_percentage_reels'] as num?)?.toDouble(),
      postPercentage: (json['post_percentage'] as num?)?.toDouble(),
      reelPercentage: (json['reel_percentage'] as num?)?.toDouble(),
      genderMalePercentage: (json['gender_male_percentage'] as num?)?.toDouble(),
      genderFemalePercentage: (json['gender_female_percentage'] as num?)?.toDouble(),
      topCities: (json['top_cities'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      topAgeRanges: (json['top_age_ranges'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      lastMediaUrl: json['last_media_url'] as String?,
    );
  }

  static List<InstagramAccount> fromMaps(List<dynamic> jsonList) {
    return jsonList.map((json) => InstagramAccount.fromMap(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instagram_id': instagramId,
      'name': name,
      'username': username,
      'profile_picture_url': profilePictureUrl,
      'followers_count': followersCount,
      'reach': reach,
      'views': views,
      'profile_views': profileViews,
      'profile_view_rate': profileViewRate,
      'website_clicks': websiteClicks,
      'link_clicks': linkClicks,
      'engagement_rate': engagementRate,
      'total_interactions': totalInteractions,
      'interaction_percentage_posts': interactionPercentagePosts,
      'interaction_percentage_reels': interactionPercentageReels,
      'post_percentage': postPercentage,
      'reel_percentage': reelPercentage,
      'gender_male_percentage': genderMalePercentage,
      'gender_female_percentage': genderFemalePercentage,
      'top_cities': topCities,
      'top_age_ranges': topAgeRanges,
      'last_media_url': lastMediaUrl,
    };
  }
}
