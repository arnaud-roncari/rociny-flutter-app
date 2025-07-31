class Review {
  final int id;
  final int collaborationId;
  final int authorId;
  final int reviewedId;
  final int stars;
  final String? description;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.collaborationId,
    required this.authorId,
    required this.reviewedId,
    required this.stars,
    this.description,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      collaborationId: json['collaboration_id'],
      authorId: json['author_id'],
      reviewedId: json['reviewed_id'],
      stars: json['stars'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collaboration_id': collaborationId,
      'author_id': authorId,
      'reviewed_id': reviewedId,
      'stars': stars,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
