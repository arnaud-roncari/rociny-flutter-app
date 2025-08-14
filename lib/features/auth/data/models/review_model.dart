class Review {
  final int id;
  final int collaborationId;
  final int authorId;
  final int reviewedId;
  final int stars;
  final String description;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.collaborationId,
    required this.authorId,
    required this.reviewedId,
    required this.stars,
    required this.description,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      collaborationId: json['collaboration_id'] as int,
      authorId: json['author_id'] as int,
      reviewedId: json['reviewed_id'] as int,
      stars: json['stars'] as int,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<Review> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
  }
}
