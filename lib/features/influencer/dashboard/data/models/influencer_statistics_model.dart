class InfluencerStatistics {
  final int revenue; // Total revenue generated
  final double averageRating; // Average rating (1-5)
  final int profileViews; // Number of profile visits
  final int collaborationsCount; // Number of collaborations
  final int placementsCount; // Number of product placements

  InfluencerStatistics({
    required this.revenue,
    required this.averageRating,
    required this.profileViews,
    required this.collaborationsCount,
    required this.placementsCount,
  });

  factory InfluencerStatistics.fromJson(Map<String, dynamic> json) {
    return InfluencerStatistics(
      revenue: json['revenue'] ?? 0,
      averageRating: (json['average_rating'] is int)
          ? (json['average_rating'] as int).toDouble()
          : (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      profileViews: json['profile_views'] ?? 0,
      collaborationsCount: json['collaborations_count'] ?? 0,
      placementsCount: json['placements_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': revenue,
      'average_rating': averageRating,
      'profile_views': profileViews,
      'collaborations_count': collaborationsCount,
      'placements_count': placementsCount,
    };
  }

  static List<InfluencerStatistics> fromJsons(List<dynamic> jsons) {
    return jsons.map((e) => InfluencerStatistics.fromJson(e as Map<String, dynamic>)).toList();
  }
}
