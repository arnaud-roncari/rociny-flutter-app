import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';

class ProductPlacement {
  final int id;
  final int collaborationId;
  final ProductPlacementType type;
  final int quantity;
  final String description;
  final int price;
  final DateTime createdAt;

  ProductPlacement({
    required this.id,
    required this.collaborationId,
    required this.type,
    required this.quantity,
    required this.description,
    required this.price,
    required this.createdAt,
  });

  factory ProductPlacement.fromJson(Map<String, dynamic> json) {
    return ProductPlacement(
      id: json['id'],
      collaborationId: json['collaboration_id'],
      type: ProductPlacementType.fromString(json['type']),
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static List<ProductPlacement> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductPlacement.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collaboration_id': collaborationId,
      'type': type.name,
      'quantity': quantity,
      'description': description,
      'price': price,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ProductPlacement.create({
    required ProductPlacementType type,
    required int quantity,
    required String description,
    required int price,
  }) {
    return ProductPlacement(
      id: 0,
      collaborationId: 0,
      type: type,
      quantity: quantity,
      description: description,
      price: price,
      createdAt: DateTime.now(),
    );
  }

  bool isSameAs(ProductPlacement other) {
    return collaborationId == other.collaborationId &&
        type == other.type &&
        quantity == other.quantity &&
        description == other.description &&
        price == other.price &&
        createdAt.isAtSameMomentAs(other.createdAt);
  }
}
