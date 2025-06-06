import '../../model/cafe/adons.dart';

abstract class CafeEvent {}

class LoadFilterOptions extends CafeEvent {}

class SearchCafes extends CafeEvent {
  final CafeSearchRequest request;

  SearchCafes({required this.request});
}

class LoadNearbyCafes extends CafeEvent {
  final double latitude;
  final double longitude;
  final double? radius;

  LoadNearbyCafes({
    required this.latitude,
    required this.longitude,
    this.radius,
  });
}

class ToggleCafeFavorite extends CafeEvent {
  final String cafeId;

  ToggleCafeFavorite({required this.cafeId});
}

class UpdateSearchQuery extends CafeEvent {
  final String query;

  UpdateSearchQuery({required this.query});
}

class ApplyFilters extends CafeEvent {
  final String? categoryId;
  final String? location;
  final PriceRangeModel? priceRange;
  final double? minRating;
  final String? sortBy;

  ApplyFilters({
    this.categoryId,
    this.location,
    this.priceRange,
    this.minRating,
    this.sortBy,
  });
}

class ClearFilters extends CafeEvent {}

class LoadMoreCafes extends CafeEvent {}