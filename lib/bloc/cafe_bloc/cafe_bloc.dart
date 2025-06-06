import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/sharedpref_key.dart';
import 'package:refreshing_co/utills/shared_preferences.dart';
import '../../model/cafe/adons.dart';
import '../../model/cafe/cafe_model.dart';
import '../../repository/cafe_repository.dart';
import 'cafe_event.dart';
import 'cafe_state.dart';

class CafeBloc extends Bloc<CafeEvent, CafeState> {
  final CafeService _cafeService;
  FilterOptionsModel? _filterOptions;
  CafeSearchRequest _currentRequest = CafeSearchRequest();
  List<CafeModel> _allCafes = [];
  Set<String> _favoriteCafeIds = {};

  CafeBloc({required CafeService cafeService})
    : _cafeService = cafeService,
      super(CafeInitial()) {
    on<LoadFilterOptions>(_onLoadFilterOptions);
    on<SearchCafes>(_onSearchCafes);
    on<LoadNearbyCafes>(_onLoadNearbyCafes);
    on<ToggleCafeFavorite>(_onToggleCafeFavorite);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
    on<LoadMoreCafes>(_onLoadMoreCafes);
  }
  Future<void> _onLoadFilterOptions(
    LoadFilterOptions event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());
    String token= await SharedPref.getString(SharedPrefKey.authTokenKey);

    try {
      final result = await _cafeService.getFilterOptions(token);

      if (result['success'] == true) {
        _filterOptions = result['data'];
        emit(CafeFilterOptionsLoaded(filterOptions: _filterOptions!));
      } else {
        emit(
          CafeError(
            message: result['message'] ?? 'Failed to load filter options',
          ),
        );
      }
    } catch (e) {
      print(e);
      emit(CafeError(message: 'Network error occurred'));
    }
  }

  Future<void> _onSearchCafes(
    SearchCafes event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());

    try {
      String token= await SharedPref.getString(SharedPrefKey.authTokenKey);

      _currentRequest = event.request;
      final result = await _cafeService.searchCafes(event.request,token);
print(result);
      if (result['success'] == true) {
        _allCafes = result['data'];
       // final meta = result['meta'] ?? {};
       // final hasMore = result['hasNextPage'] ?? false;

        emit(
          CafeSearchSuccess(
            cafes: _allCafes,
           // meta: meta,
            hasMore: true,
            currentRequest: _currentRequest,
          ),
        );
      } else {
        emit(CafeError(message: result['message'][0] ?? 'Failed to search cafes'));
      }
    } catch (e) {
      print(e);

      emit(CafeError(message: 'Network error occurred'));
    }
  }

  Future<void> _onLoadNearbyCafes(
    LoadNearbyCafes event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());
    String token= await SharedPref.getString(SharedPrefKey.authTokenKey);

    try {
      final result = await _cafeService.getNearbyCafes(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius, token: token,
      );

      if (result['success'] == true) {
        final nearbyCafes = result['data'] as List<CafeModel>;
        emit(CafeNearbyLoaded(nearbyCafes: nearbyCafes));
      } else {
        emit(
          CafeError(
            message: result['message'] ?? 'Failed to load nearby cafes',
          ),
        );
      }
    } catch (e) {
      print(e);

      emit(CafeError(message: 'Network error occurred'));
    }
  }

  Future<void> _onToggleCafeFavorite(
    ToggleCafeFavorite event,
    Emitter<CafeState> emit,
  ) async {
    try {
      String token= await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cafeService.toggleFavorite(event.cafeId,token);
print(result);
      if (result['success'] == true) {
        final isFavorite = result['isFavorite'] ?? false;

        if (isFavorite) {
          _favoriteCafeIds.add(event.cafeId);
        } else {
          _favoriteCafeIds.remove(event.cafeId);
        }

        emit(
          CafeFavoriteUpdated(
            cafeId: event.cafeId,
            isFavorite: isFavorite,
            message: result['message'] ?? 'Favorite updated',
          ),
        );

        // Re-emit the current state with updated favorites
        if (state is CafeSearchSuccess) {
          final currentState = state as CafeSearchSuccess;
          emit(
            CafeSearchSuccess(
              cafes: currentState.cafes,
             // meta: currentState.meta,
              hasMore: true,///currentState.hasMore,
              currentRequest: currentState.currentRequest,
            ),
          );
        }
      } else {
        emit(
          CafeError(message: result['message'] ?? 'Failed to update favorite'),
        );
      }
    } catch (e) {
      print(e);

      emit(CafeError(message: 'Network error occurred'));
    }
  }

  Future<void> _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<CafeState> emit,
  ) async {
    final newRequest = _currentRequest.copyWith(
      search: event.query.isEmpty ? null : event.query,
      page: 1,
    );

    add(SearchCafes(request: newRequest));
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<CafeState> emit,
  ) async {
    final newRequest = _currentRequest.copyWith(
      categoryId: event.categoryId,
      city: event.location,
      priceRange: event.priceRange,
      minRatingFilter: event.minRating,
      sortBy: event.sortBy,
      page: 1,
    );

    add(SearchCafes(request: newRequest));
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<CafeState> emit,
  ) async {
    final newRequest = CafeSearchRequest(
      search: _currentRequest.search,
      limit: _currentRequest.limit,
    );

    add(SearchCafes(request: newRequest));
  }

  Future<void> _onLoadMoreCafes(
    LoadMoreCafes event,
    Emitter<CafeState> emit,
  ) async {
    if (state is CafeSearchSuccess) {
      final currentState = state as CafeSearchSuccess;

      if (!currentState.hasMore) return;

      emit(CafeLoadingMore(currentCafes: currentState.cafes));

      try {
        final nextPage = (currentState.currentRequest.page ?? 1) + 1;
        final newRequest = currentState.currentRequest.copyWith(page: nextPage);
      String token= await SharedPref.getString(SharedPrefKey.authTokenKey);

        final result = await _cafeService.searchCafes(newRequest,token);

        if (result['success'] == true) {
          final newCafes = result['data'] as List<CafeModel>;
          final allCafes = [...currentState.cafes, ...newCafes];
          final meta = result['meta'] ?? {};
          final hasMore = meta['hasNextPage'] ?? false;

          _allCafes = allCafes;
          _currentRequest = newRequest;

          emit(
            CafeSearchSuccess(
              cafes: allCafes,
             // meta: meta,
              hasMore:true, //hasMore,
              currentRequest: _currentRequest,
            ),
          );
        } else {
          emit(
            CafeError(
              message: result['message'] ?? 'Failed to load more cafes',
            ),
          );
        }
      } catch (e) {
        print(e);

        emit(CafeError(message: 'Network error occurred'));
      }
    }
  }

  bool isCafeFavorite(String cafeId) {
    return _favoriteCafeIds.contains(cafeId);
  }

  FilterOptionsModel? get filterOptions => _filterOptions;
}
