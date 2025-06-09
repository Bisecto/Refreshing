import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/bloc/product_bloc/product_event.dart';
import 'package:refreshing_co/bloc/product_bloc/product_state.dart';
import 'package:refreshing_co/repository/auth_service.dart';
import '../../model/cafe/cafe_model.dart';
import '../../model/product/cart_item.dart';
import '../../model/product/product_model.dart';
import '../../repository/product_service.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/shared_preferences.dart';
import '../cart_bloc/cart_bloc.dart';
import '../cart_bloc/cart_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;
  final AuthRepository authService;
  bool _useAutoTokens = true; // Toggle for migration

  final CartBloc cartBloc;

  CafeModel? _currentCafe;
  List<ProductModel> _allProducts = [];
  List<CartItem> _cartItems = [];
  String? _currentCafeId;
  int _currentPage = 1;

  ProductBloc({
    required this.productService,
    required this.cartBloc,
    required this.authService,

    bool useAutoTokens = true, // Default to using auto tokens
  }) : _useAutoTokens = useAutoTokens,
        super(ProductInitial()) {
    on<LoadCafeDetails>(_onLoadCafeDetails);
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
   // on<AddToCartFromProduct>(_onAddToCartFromProduct);
    on<ToggleAutoTokens>(_onToggleAutoTokens);
  }

  Future<void> _onLoadCafeDetails(
      LoadCafeDetails event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    try {
      Map<String, dynamic> result;

      if (_useAutoTokens) {
        // Use automatic token management
        result = await productService.getCafeDetails(event.cafeId);
      } else {
        // Use manual token (backward compatibility)
        String token = await SharedPref.getString(SharedPrefKey.authTokenKey);
        result = await productService.getCafeDetails(
          event.cafeId,
          token: token,
        );
      }

      if (result['success'] == true) {
        _currentCafe = result['data'];
        _currentCafeId = event.cafeId;
        emit(CafeDetailsLoaded(cafe: _currentCafe!));

        // Auto-load products for this cafe
        add(LoadProducts(cafeId: event.cafeId));
      } else {
        emit(
          ProductError(
            message: result['message'] ?? 'Failed to load cafe details',
          ),
        );
      }
    } catch (e) {
      // Check if it's a token-related error and try to refresh
      if (e.toString().contains('401') || e.toString().contains('unauthorized')) {
        print('Token error detected, attempting refresh...');
        try {
          final refreshResult = await authService.refreshToken();
          if (refreshResult['success'] == true) {
            print('Token refreshed, retrying cafe details...');
            // Retry the request
            add(event);
            return;
          }
        } catch (refreshError) {
          print('Token refresh failed: $refreshError');
        }
      }

      emit(ProductError(message: 'Network error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (_currentCafe == null) {
      emit(ProductLoading());
    }

    try {
      _currentCafeId = event.cafeId;
      _currentPage = event.page;

      Map<String, dynamic> result;

      if (_useAutoTokens) {
        // Use automatic token management with enhanced parameters
        result = await productService.getProductsAuto(
          cafeId: event.cafeId,
          page: event.page,
          limit: event.limit,
          category: event.category,
          search: event.search,
          isAvailable: event.isAvailable,
        );
      } else {
        // Use manual token (backward compatibility)
        String token = await SharedPref.getString(SharedPrefKey.authTokenKey);
        result = await productService.getProducts(
          cafeId: event.cafeId,
          page: event.page,
          limit: event.limit,
          token: token,
        );
      }

      if (result['success'] == true) {
        _allProducts = result['data'];
        final meta = result['meta'] ?? {};
        final hasMore = meta['hasNextPage'] ?? false;

        emit(
          ProductsLoaded(
            products: _allProducts,
            meta: meta,
            hasMore: hasMore,
            cafeId: event.cafeId,
          ),
        );
      } else {
        emit(
          ProductError(message: result['message'] ?? 'Failed to load products'),
        );
      }
    } catch (e) {
      // Check if it's a token-related error and try to refresh
      if (e.toString().contains('401') || e.toString().contains('unauthorized')) {
        print('Token error detected, attempting refresh...');
        try {
          final refreshResult = await authService.refreshToken();
          if (refreshResult['success'] == true) {
            print('Token refreshed, retrying products...');
            // Retry the request
            add(event);
            return;
          }
        } catch (refreshError) {
          print('Token refresh failed: $refreshError');
        }
      }

      emit(ProductError(message: 'Network error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (state is ProductsLoaded && _currentCafeId != null) {
      final currentState = state as ProductsLoaded;

      if (!currentState.hasMore) return;

      emit(ProductLoadingMore(currentProducts: currentState.products));

      try {
        final nextPage = _currentPage + 1;

        Map<String, dynamic> result;

        if (_useAutoTokens) {
          // Use automatic token management
          result = await productService.getProductsAuto(
            cafeId: _currentCafeId!,
            page: nextPage,
            limit: 10,
          );
        } else {
          // Use manual token (backward compatibility)
          String token = await SharedPref.getString(SharedPrefKey.authTokenKey);
          result = await productService.getProducts(
            cafeId: _currentCafeId!,
            page: nextPage,
            limit: 10,
            token: token,
          );
        }

        if (result['success'] == true) {
          final newProducts = result['data'] as List<ProductModel>;
          final allProducts = [...currentState.products, ...newProducts];
          final meta = result['meta'] ?? {};
          final hasMore = meta['hasNextPage'] ?? false;

          _allProducts = allProducts;
          _currentPage = nextPage;

          emit(
            ProductsLoaded(
              products: allProducts,
              meta: meta,
              hasMore: hasMore,
              cafeId: _currentCafeId!,
            ),
          );
        } else {
          emit(
            ProductError(
              message: result['message'] ?? 'Failed to load more products',
            ),
          );
        }
      } catch (e) {
        // Check if it's a token-related error and try to refresh
        if (e.toString().contains('401') || e.toString().contains('unauthorized')) {
          print('Token error detected, attempting refresh...');
          try {
            final refreshResult = await authService.refreshToken();
            if (refreshResult['success'] == true) {
              print('Token refreshed, retrying load more products...');
              // Retry the request
              add(event);
              return;
            }
          } catch (refreshError) {
            print('Token refresh failed: $refreshError');
          }
        }

        emit(ProductError(message: 'Network error occurred: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadProductDetails(
      LoadProductDetails event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    try {
      Map<String, dynamic> result;

      if (_useAutoTokens) {
        // Use automatic token management
        result = await productService.getProductDetailsAuto(event.productId);
      } else {
        // Use manual token (backward compatibility)
        String token = await SharedPref.getString(SharedPrefKey.authTokenKey);
        result = await productService.getProductDetails(
          event.productId,
          token: token,
        );
      }

      if (result['success'] == true) {
        final product = result['data'];
        emit(ProductDetailsLoaded(product: product));
      } else {
        emit(
          ProductError(
            message: result['message'] ?? 'Failed to load product details',
          ),
        );
      }
    } catch (e) {
      // Check if it's a token-related error and try to refresh
      if (e.toString().contains('401') || e.toString().contains('unauthorized')) {
        print('Token error detected, attempting refresh...');
        try {
          final refreshResult = await authService.refreshToken();
          if (refreshResult['success'] == true) {
            print('Token refreshed, retrying product details...');
            // Retry the request
            add(event);
            return;
          }
        } catch (refreshError) {
          print('Token refresh failed: $refreshError');
        }
      }

      emit(ProductError(message: 'Network error occurred: ${e.toString()}'));
    }
  }

  // Future<void> _onAddToCartFromProduct(
  //     AddToCartFromProduct event,
  //     Emitter<ProductState> emit,
  //     ) async {
  //   try {
  //     // Convert customizations to the format expected by the API
  //     final customizationsMap = <String, dynamic>{};
  //
  //
  //     // Use CartBloc to add to cart via API
  //     cartBloc.add(
  //       AddToCartEvent(
  //         productId: event.product.id,
  //         quantity: event.quantity,
  //         customizations: customizationsMap,
  //       ),
  //     );
  //
  //     emit(
  //       ProductAddedToCart(
  //         message: '${event.product.name} added to cart successfully',
  //       ),
  //     );
  //   } catch (e) {
  //     emit(ProductError(message: 'Failed to add product to cart: ${e.toString()}'));
  //   }
  // }

  // New event handler for toggling auto token feature
  Future<void> _onToggleAutoTokens(
      ToggleAutoTokens event,
      Emitter<ProductState> emit,
      ) async {
    _useAutoTokens = event.enabled;

    // Optionally emit a state to notify UI of the change
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(ProductsLoaded(
        products: currentState.products,
        meta: currentState.meta,
        hasMore: currentState.hasMore,
        cafeId: currentState.cafeId,
        autoTokensEnabled: _useAutoTokens,
      ));
    }
  }

  // Helper method to check if auto tokens are enabled
  bool get isAutoTokensEnabled => _useAutoTokens;

  // Method to manually refresh token
  Future<bool> refreshToken() async {
    try {
      final result = await authService.refreshToken();
      return result['success'] == true;
    } catch (e) {
      print('Manual token refresh failed: $e');
      return false;
    }
  }

  // Method to validate current token
  Future<bool> validateToken() async {
    try {
      final tokenResult = await authService.getValidToken();
      return tokenResult['success'] == true;
    } catch (e) {
      print('Token validation failed: $e');
      return false;
    }
  }

  // Getters (fixed syntax)
  CafeModel? get currentCafe => _currentCafe;
  List<CartItem> get cartItems => List.from(_cartItems);
  double get cartTotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  String? get currentCafeId => _currentCafeId;
  int get currentPage => _currentPage;
  List<ProductModel> get allProducts => List.from(_allProducts);
}

// Add this new event to your product_event.dart
class ToggleAutoTokens extends ProductEvent {
  final bool enabled;

  ToggleAutoTokens({required this.enabled});
}




