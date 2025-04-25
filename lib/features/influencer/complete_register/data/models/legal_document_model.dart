import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';

class LegalDocument {
  final int id;
  final String document;
  final LegalDocumentType type;
  final LegalDocumentStatus status;

  LegalDocument({
    required this.id,
    required this.document,
    required this.type,
    required this.status,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'],
      document: json['document'],
      type: LegalDocumentType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      status: LegalDocumentStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
    );
  }

  static List<LegalDocument> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((json) => LegalDocument.fromJson(json)).toList();
  }
}
