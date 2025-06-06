import '../../model/cafe/adons.dart';
import '../../model/cafe/cafe_model.dart';

abstract class CafeState {}

class CafeInitial extends CafeState {}

class CafeLoading extends CafeState {}

class CafeFilterOptionsLoaded extends CafeState {
  final FilterOptionsModel filterOptions;

  CafeFilterOptionsLoaded({required this.filterOptions});
}

class CafeSearchSuccess extends CafeState {
  final List<CafeModel> cafes;
  // final Map<String, dynamic> meta;
  final bool hasMore;
  final CafeSearchRequest currentRequest;

  CafeSearchSuccess({
    required this.cafes,
    //required this.meta,
    required this.hasMore,
    required this.currentRequest,
  });
}

class CafeNearbyLoaded extends CafeState {
  final List<CafeModel> nearbyCafes;

  CafeNearbyLoaded({required this.nearbyCafes});
}

class CafeFavoriteUpdated extends CafeState {
  final String cafeId;
  final bool isFavorite;
  final String message;

  CafeFavoriteUpdated({
    required this.cafeId,
    required this.isFavorite,
    required this.message,
  });
}

class CafeError extends CafeState {
  final String message;

  CafeError({required this.message});
}

class CafeLoadingMore extends CafeState {
  final List<CafeModel> currentCafes;

  CafeLoadingMore({required this.currentCafes});
}
