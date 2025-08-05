import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';

/// TODO ajouter els exception du service collaboration
class ProductPlacement {
  final int id;
  final ProductPlacementType type;
  final int quantity;
  final String description;
  final int price;

  ProductPlacement({
    required this.id,
    required this.type,
    required this.quantity,
    required this.description,
    required this.price,
  });

  factory ProductPlacement.fromJson(Map<String, dynamic> json) {
    return ProductPlacement(
      id: json['id'],
      type: ProductPlacementType.fromString(json['type']),
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
    );
  }

  static List<ProductPlacement> fromJsons(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductPlacement.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'quantity': quantity,
      'description': description,
      'price': price,
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
      type: type,
      quantity: quantity,
      description: description,
      price: price,
    );
  }

  bool isSameAs(ProductPlacement other) {
    return type == other.type && quantity == other.quantity && description == other.description && price == other.price;
  }

  static List<Map<String, dynamic>> toJsons(List<ProductPlacement> list) {
    return list.map((e) => e.toJson()).toList();
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'type': type.name,
      'quantity': quantity,
      'description': description,
      'price': price,
    };
  }

  static List<Map<String, dynamic>> toCreateJsons(List<ProductPlacement> list) {
    return list.map((e) => e.toCreateJson()).toList();
  }
}
