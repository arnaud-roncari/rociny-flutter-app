import 'package:rociny/features/company/search/data/models/product_placement_model.dart';

class Collaboration {
  final int id;
  final int companyId;
  int influencerId;
  String title;
  final List<String> files;
  final String status;
  final String platformQuote;
  final String influencerQuote;
  final String? platformInvoice;
  final String? influencerInvoice;
  final List<ProductPlacement> productPlacements;
  final DateTime createdAt;

  Collaboration({
    required this.id,
    required this.companyId,
    required this.influencerId,
    required this.title,
    required this.files,
    required this.status,
    this.influencerInvoice,
    this.platformInvoice,
    required this.platformQuote,
    required this.influencerQuote,
    required this.productPlacements,
    required this.createdAt,
  });
  factory Collaboration.empty() {
    return Collaboration(
      id: 0,
      companyId: 0,
      influencerId: 0,
      title: '',
      files: [],
      status: '',
      platformQuote: '',
      influencerQuote: '',
      productPlacements: [],
      createdAt: DateTime.now(),
    );
  }
  factory Collaboration.fromJson(Map<String, dynamic> json) {
    return Collaboration(
      id: json['id'],
      companyId: json['company_id'],
      influencerId: json['influencer_id'],
      title: json['title'],
      files: List<String>.from(json['files'] ?? []),
      status: json['status'],
      influencerQuote: json['influencer_quote'],
      influencerInvoice: json['influencer_invoice'],
      platformQuote: json['platform_quote'],
      platformInvoice: json['platform_invoice'],
      productPlacements: ProductPlacement.fromJsons(json['product_placements']),
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
      'product_placements': ProductPlacement.toJsons(productPlacements),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'company_id': companyId,
      'influencer_id': influencerId,
      'title': title,
      'product_placements': ProductPlacement.toCreateJsons(productPlacements),
    };
  }

  int getPrice() {
    return productPlacements.fold(
      0,
      (sum, pp) => sum + pp.price,
    );
  }
}
