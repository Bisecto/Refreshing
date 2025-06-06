import 'category_model.dart';
import 'location_model.dart';

class PriceRangeModel {
  final String label;
  final double min;
  final double? max;

  PriceRangeModel({
    required this.label,
    required this.min,
    this.max,
  });

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
      label: json['label'] ?? '',
      min: (json['min'] ?? 0.0).toDouble(),
      max: json['max']?.toDouble(),
    );
  }
}

class RatingRangeModel {
  final String label;
  final double min;
  final double max;

  RatingRangeModel({
    required this.label,
    required this.min,
    required this.max,
  });

  factory RatingRangeModel.fromJson(Map<String, dynamic> json) {
    return RatingRangeModel(
      label: json['label'] ?? '',
      min: (json['min'] ?? 0.0).toDouble(),
      max: (json['max'] ?? 5.0).toDouble(),
    );
  }
}

class SortOptionModel {
  final String value;
  final String label;

  SortOptionModel({
    required this.value,
    required this.label,
  });

  factory SortOptionModel.fromJson(Map<String, dynamic> json) {
    return SortOptionModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}

class FilterOptionsModel {
  final List<CategoryModel> categories;
  final List<LocationModel> locations;
  final List<PriceRangeModel> priceRanges;
  final List<RatingRangeModel> ratingRanges;
  final List<SortOptionModel> sortOptions;

  FilterOptionsModel({
    required this.categories,
    required this.locations,
    required this.priceRanges,
    required this.ratingRanges,
    required this.sortOptions,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionsModel(
      categories: (json['categories'] as List?)?.map((e) => CategoryModel.fromJson(e)).toList() ?? [],
      locations: (json['locations'] as List?)?.map((e) => LocationModel.fromJson(e)).toList() ?? [],
      priceRanges: (json['priceRanges'] as List?)?.map((e) => PriceRangeModel.fromJson(e)).toList() ?? [],
      ratingRanges: (json['ratingRanges'] as List?)?.map((e) => RatingRangeModel.fromJson(e)).toList() ?? [],
      sortOptions: (json['sortOptions'] as List?)?.map((e) => SortOptionModel.fromJson(e)).toList() ?? [],
    );
  }
}

class CafeSearchRequest {
  final String? search;
  final int? limit;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? state;
  final String? country;
  final String? categoryId;
  final String? cafeId;
  final PriceRangeModel? priceRange;
  final double? minRatingFilter;
  final String? sortBy;
  final int? page;

  CafeSearchRequest({
    this.search,
    this.limit = 20,
    this.latitude,
    this.longitude,
    this.city,
    this.state,
    this.country,
    this.categoryId,
    this.cafeId,
    this.priceRange,
    this.minRatingFilter,
    this.sortBy = 'relevance',
    this.page = 1,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (search != null && search!.isNotEmpty) map['search'] = search;
    if (limit != null) map['limit'] = limit;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (state != null && state!.isNotEmpty) map['state'] = state;
    if (country != null && country!.isNotEmpty) map['country'] = country;
    if (categoryId != null && categoryId!.isNotEmpty) map['categoryId'] = categoryId;
    if (cafeId != null && cafeId!.isNotEmpty) map['cafeId'] = cafeId;
    if (priceRange != null) {
      map['priceMin'] = priceRange!.min;
      if (priceRange!.max != null) map['priceMax'] = priceRange!.max;
    }
    if (minRatingFilter != null) map['minRatingFilter'] = minRatingFilter;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (page != null) map['page'] = page;

    return map;
  }

  CafeSearchRequest copyWith({
    String? search,
    int? limit,
    double? latitude,
    double? longitude,
    String? city,
    String? state,
    String? country,
    String? categoryId,
    String? cafeId,
    PriceRangeModel? priceRange,
    double? minRatingFilter,
    String? sortBy,
    int? page,
  }) {
    return CafeSearchRequest(
      search: search ?? this.search,
      limit: limit ?? this.limit,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      categoryId: categoryId ?? this.categoryId,
      cafeId: cafeId ?? this.cafeId,
      priceRange: priceRange ?? this.priceRange,
      minRatingFilter: minRatingFilter ?? this.minRatingFilter,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
    );
  }
}
