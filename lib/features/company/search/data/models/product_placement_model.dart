class ProductPlacement {
  final int id;
  final int collaborationId;
  final String type;
  final int quantity;
  final String? description;
  final int price;
  final DateTime createdAt;

  ProductPlacement({
    required this.id,
    required this.collaborationId,
    required this.type,
    required this.quantity,
    this.description,
    required this.price,
    required this.createdAt,
  });

  factory ProductPlacement.fromJson(Map<String, dynamic> json) {
    return ProductPlacement(
      id: json['id'],
      collaborationId: json['collaboration_id'],
      type: json['type'],
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collaboration_id': collaborationId,
      'type': type,
      'quantity': quantity,
      'description': description,
      'price': price,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
