class CartItemModel {
  final String id;
  final String productId;
  final int quantity;
  final Map<String, dynamic> customizations;
  final double price;
  final String productName;
  final String productImage;
  final String? productDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.customizations,
    required this.price,
    required this.productName,
    required this.productImage,
    this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      customizations: Map<String, dynamic>.from(json['customizations'] ?? {}),
      price: (json['price'] ?? 0.0).toDouble(),
      productName: json['product']?['name'] ?? '',
      productImage: json['product']?['images']?.first?['url'] ?? '',
      productDescription: json['product']?['description'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'customizations': customizations,
    };
  }

  double get totalPrice => price * quantity;

  String get customizationDisplay {
    if (customizations.isEmpty) return '';

    final customizationStrings = customizations.entries
        .map((e) => '${e.key}: ${e.value}')
        .toList();

    return customizationStrings.join(', ');
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    int? quantity,
    Map<String, dynamic>? customizations,
    double? price,
    String? productName,
    String? productImage,
    String? productDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      price: price ?? this.price,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productDescription: productDescription ?? this.productDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CartSummary {
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double total;
  final int itemCount;

  CartSummary({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  factory CartSummary.fromItems(List<CartItemModel> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.1; // 10% tax
    final total = subtotal + tax;
    final itemCount = items.fold(0, (sum, item) => sum + item.quantity);

    return CartSummary(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      itemCount: itemCount,
    );
  }

  bool get isEmpty => items.isEmpty;
}