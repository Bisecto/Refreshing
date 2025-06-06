import 'cafe_count.dart';
import 'cafe_image.dart';

class CafeModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final bool isActive;
  final double averageRating;
  final int totalReviews;
  final int estimatedPrepTime;
  final double deliveryRadius;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final List<CafeImage> images;
  final CafeCount count;

  CafeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.isActive,
    required this.averageRating,
    required this.totalReviews,
    required this.estimatedPrepTime,
    required this.deliveryRadius,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.images,
    required this.count,
  });

  factory CafeModel.fromJson(Map<String, dynamic> json) {
    return CafeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      estimatedPrepTime: json['estimatedPrepTime'] ?? 0,
      deliveryRadius: (json['deliveryRadius'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      createdBy: json['createdBy'] ?? '',
      images: (json['images'] as List?)?.map((e) => CafeImage.fromJson(e)).toList() ?? [],
      count: CafeCount.fromJson(json['_count'] ?? {}),
    );
  }

  String get primaryImageUrl {
    final primaryImage = images.firstWhere(
          (image) => image.isPrimary,
      orElse: () => images.isNotEmpty ? images.first : CafeImage.empty(),
    );
    return primaryImage.url;
  }

  String get fullAddress => '$address, $city, $state $postalCode, $country';

  String get displayLocation => '$city, $country';
}
