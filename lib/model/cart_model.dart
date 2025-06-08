class CartResponse {
  final List<CartItemModel> items;
  final CartSummary summary;

  CartResponse({
    required this.items,
    required this.summary,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      summary: CartSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}

class CartItemModel {
  final String id;
  final int quantity;
  final Map<String, dynamic> customizations;
  final String totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String productId;
  final ProductInCart product;

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.productId,
    required this.product,
  });

  // Computed properties for easier access
  String get productName => product.name;
  String get productImage => product.primaryImageUrl;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      customizations: Map<String, dynamic>.from(json['customizations'] ?? {}),
      totalPrice: json['totalPrice'] ?? '0.00',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      product: ProductInCart.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'customizations': customizations,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'productId': productId,
      'product': product.toJson(),
    };
  }

  CartItemModel copyWith({
    String? id,
    int? quantity,
    Map<String, dynamic>? customizations,
    String? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? productId,
    ProductInCart? product,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      product: product ?? this.product,
    );
  }
}

class ProductInCart {
  final String id;
  final String name;
  final String description;
  final String basePrice;
  final bool isAvailable;
  final double averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String categoryId;
  final String cafeId;
  final List<ProductImage> images;
  final ProductCategory category;

  ProductInCart({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.isAvailable,
    required this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.categoryId,
    required this.cafeId,
    required this.images,
    required this.category,
  });

  String get primaryImageUrl {
    final primaryImage = images.where((img) => img.isPrimary).firstOrNull;
    return primaryImage?.url ?? (images.isNotEmpty ? images.first.url : '');
  }

  factory ProductInCart.fromJson(Map<String, dynamic> json) {
    return ProductInCart(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: json['basePrice'] ?? '0.00',
      isAvailable: json['isAvailable'] ?? false,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      categoryId: json['categoryId'] ?? '',
      cafeId: json['cafeId'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((img) => ProductImage.fromJson(img as Map<String, dynamic>))
          .toList() ?? [],
      category: ProductCategory.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'isAvailable': isAvailable,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'categoryId': categoryId,
      'cafeId': cafeId,
      'images': images.map((img) => img.toJson()).toList(),
      'category': category.toJson(),
    };
  }
}

class ProductImage {
  final String id;
  final String url;
  final String altText;
  final bool isPrimary;
  final DateTime createdAt;
  final String productId;

  ProductImage({
    required this.id,
    required this.url,
    required this.altText,
    required this.isPrimary,
    required this.createdAt,
    required this.productId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      productId: json['productId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'altText': altText,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'productId': productId,
    };
  }
}

class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CartSummary {
  final int itemCount;
  final String total;

  CartSummary({
    required this.itemCount,
    required this.total,
  });

  bool get isEmpty => itemCount == 0;

  List<CartItemModel> get items => []; // This will be set from CartResponse

  double get totalAsDouble => double.tryParse(total) ?? 0.0;
  double get subtotal => totalAsDouble; // Adjust based on your needs
  double get tax => 1.0; // Fixed tax for now, adjust as needed

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      itemCount: json['itemCount'] ?? 0,
      total: json['total'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCount': itemCount,
      'total': total,
    };
  }

  CartSummary copyWith({
    int? itemCount,
    String? total,
  }) {
    return CartSummary(
      itemCount: itemCount ?? this.itemCount,
      total: total ?? this.total,
    );
  }
}

// Extension to add items list to CartSummary
extension CartSummaryWithItems on CartSummary {
  CartSummary withItems(List<CartItemModel> items) {
    return CartSummaryWithItemsList(
      itemCount: itemCount,
      total: total,
      items: items,
    );
  }
}

class CartSummaryWithItemsList extends CartSummary {
  @override
  final List<CartItemModel> items;

  CartSummaryWithItemsList({
    required int itemCount,
    required String total,
    required this.items,
  }) : super(itemCount: itemCount, total: total);
}