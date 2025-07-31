class Collaboration {
  final int id;
  final int companyId;
  final int influencerId;
  final String title;
  final List<String> files;
  final String status;
  final DateTime createdAt;

  Collaboration({
    required this.id,
    required this.companyId,
    required this.influencerId,
    required this.title,
    required this.files,
    required this.status,
    required this.createdAt,
  });

  factory Collaboration.fromJson(Map<String, dynamic> json) {
    return Collaboration(
      id: json['id'],
      companyId: json['company_id'],
      influencerId: json['influencer_id'],
      title: json['title'],
      files: List<String>.from(json['files'] ?? []),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'influencer_id': influencerId,
      'title': title,
      'files': files,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
