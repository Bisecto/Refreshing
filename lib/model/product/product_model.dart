import '../cafe/cafe_model.dart';
import '../cafe/category_model.dart';

class ProductModel {
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
  final String? cafeId;
  final CategoryModel category;
  final CafeModel? cafe;
  final List<ProductImage> images;

  ProductModel({
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
    this.cafeId,
    required this.category,
    this.cafe,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: json['basePrice'] ?? '0.0',
      isAvailable: json['isAvailable'] ?? false,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      createdBy: json['createdBy'] ?? '',
      categoryId: json['categoryId'] ?? '',
      cafeId: json['cafeId'],
      category: CategoryModel.fromJson(json['category'] ?? {}),
      cafe: json['cafe'] != null ? CafeModel.fromJson(json['cafe']) : null,
      images: (json['images'] as List?)?.map((e) => ProductImage.fromJson(e)).toList() ?? [],
    );
  }

  String get primaryImageUrl {
    final primaryImage = images.firstWhere(
          (image) => image.isPrimary,
      orElse: () => images.isNotEmpty ? images.first : ProductImage.empty(),
    );
    return primaryImage.url;
  }

  double get priceAsDouble => double.tryParse(basePrice) ?? 0.0;
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
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      productId: json['productId'] ?? '',
    );
  }

  factory ProductImage.empty() {
    return ProductImage(
      id: '',
      url: '',
      altText: '',
      isPrimary: false,
      createdAt: DateTime.now(),
      productId: '',
    );
  }
}

class ProductCustomization {
  final String type;
  final String selectedValue;
  final List<String> options;

  ProductCustomization({
    required this.type,
    required this.selectedValue,
    required this.options,
  });

  ProductCustomization copyWith({
    String? type,
    String? selectedValue,
    List<String>? options,
  }) {
    return ProductCustomization(
      type: type ?? this.type,
      selectedValue: selectedValue ?? this.selectedValue,
      options: options ?? this.options,
    );
  }
}

