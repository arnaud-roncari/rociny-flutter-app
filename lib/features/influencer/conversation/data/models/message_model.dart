import 'package:intl/intl.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';

class Message {
  final int id;
  final int conversationId;
  final String senderType; // "influencer" | "company"
  final int senderId;
  final String? content;
  final bool isRead;
  final DateTime createdAt;
  final int? collaborationId;
  final CollaborationSummary? collaboration;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.collaborationId,
    this.collaboration,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      senderType: json['sender_type'] as String,
      senderId: json['sender_id'] as int,
      content: json['content'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      collaborationId: json['collaboration_id'],
      collaboration: json['collaboration'] == null ? null : CollaborationSummary.fromJson(json['collaboration']),
    );
  }

  static List<Message> fromJsons(List<dynamic> jsons) {
    return jsons.map((j) => Message.fromJson(j as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_type': senderType,
      'sender_id': senderId,
      'content': content,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'collaboration_id': collaborationId,
      'collaboration': collaboration?.toJson(),
    };
  }

  String getTime() {
    return DateFormat.Hm().format(createdAt);
  }

  String getDayLabel() {
    var raw = DateFormat('EEEE d MMMM', 'fr_FR').format(createdAt);
    return _capitalizeWords(raw);
  }

  String _capitalizeWords(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
