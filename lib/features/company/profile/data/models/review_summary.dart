class ReviewSummary {
  final int userId;
  final String name;
  final String? profilePicture;
  final String description;

  ReviewSummary({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.description,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      userId: json['user_id'] as int,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'profile_picture': profilePicture,
      'description': description,
    };
  }

  static List<ReviewSummary> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((e) => ReviewSummary.fromJson(e as Map<String, dynamic>)).toList();
  }
}
