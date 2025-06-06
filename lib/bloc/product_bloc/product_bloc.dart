import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/bloc/product_bloc/product_event.dart';
import 'package:refreshing_co/bloc/product_bloc/product_state.dart';
import '../../model/cafe/cafe_model.dart';
import '../../model/product/cart_item.dart';
import '../../model/product/product_model.dart';
import '../../repository/product_service.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;
  CafeModel? _currentCafe;
  List<ProductModel> _allProducts = [];
  List<CartItem> _cartItems = [];
  String? _currentCafeId;
  int _currentPage = 1;

  ProductBloc({required ProductService productService})
      : _productService = productService,
        super(ProductInitial()) {
    on<LoadCafeDetails>(_onLoadCafeDetails);
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCafeDetails(
      LoadCafeDetails event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    try {
      final result = await _productService.getCafeDetails(event.cafeId);

      if (result['success'] == true) {
        _currentCafe = result['data'];
        _currentCafeId = event.cafeId;
        emit(CafeDetailsLoaded(cafe: _currentCafe!));

        // Auto-load products for this cafe
        add(LoadProducts(cafeId: event.cafeId));
      } else {
        emit(ProductError(message: result['message'] ?? 'Failed to load cafe details'));
      }
    } catch (e) {
      emit(ProductError(message: 'Network error occurred'));
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

      final result = await _productService.getProducts(
        cafeId: event.cafeId,
        page: event.page,
        limit: event.limit,
      );

      if (result['success'] == true) {
        _allProducts = result['data'];
        final meta = result['meta'] ?? {};
        final hasMore = meta['hasNextPage'] ?? false;

        emit(ProductsLoaded(
          products: _allProducts,
          meta: meta,
          hasMore: hasMore,
          cafeId: event.cafeId,
        ));
      } else {
        emit(ProductError(message: result['message'] ?? 'Failed to load products'));
      }
    } catch (e) {
      emit(ProductError(message: 'Network error occurred'));
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

        final result = await _productService.getProducts(
          cafeId: _currentCafeId!,
          page: nextPage,
          limit: 10,
        );

        if (result['success'] == true) {
          final newProducts = result['data'] as List<ProductModel>;
          final allProducts = [...currentState.products, ...newProducts];
          final meta = result['meta'] ?? {};
          final hasMore = meta['hasNextPage'] ?? false;

          _allProducts = allProducts;
          _currentPage = nextPage;

          emit(ProductsLoaded(
            products: allProducts,
            meta: meta,
            hasMore: hasMore,
            cafeId: _currentCafeId!,
          ));
        } else {
          emit(ProductError(message: result['message'] ?? 'Failed to load more products'));
        }
      } catch (e) {
        emit(ProductError(message: 'Network error occurred'));
      }
    }
  }

  Future<void> _onLoadProductDetails(
      LoadProductDetails event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    try {
      final result = await _productService.getProductDetails(event.productId);

      if (result['success'] == true) {
        final product = result['data'];
        emit(ProductDetailsLoaded(product: product));
      } else {
        emit(ProductError(message: result['message'] ?? 'Failed to load product details'));
      }
    } catch (e) {
      emit(ProductError(message: 'Network error occurred'));
    }
  }

  Future<void> _onAddToCart(
      AddToCart event,
      Emitter<ProductState> emit,
      ) async {
    // Check if product already exists in cart
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.product.id == event.product.id,
    );

    if (existingItemIndex != -1) {
      // Update existing item
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      // Add new item
      _cartItems.add(CartItem(
        product: event.product,
        quantity: event.quantity,
        customizations: event.customizations,
        specialInstructions: event.specialInstructions,
      ));
    }

    final totalAmount = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    emit(CartUpdated(
      cartItems: List.from(_cartItems),
      totalAmount: totalAmount,
    ));
  }

  Future<void> _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event,
      Emitter<ProductState> emit,
      ) async {
    final itemIndex = _cartItems.indexWhere(
          (item) => item.product.id == event.productId,
    );

    if (itemIndex != -1) {
      if (event.quantity <= 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
          quantity: event.quantity,
        );
      }

      final totalAmount = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

      emit(CartUpdated(
        cartItems: List.from(_cartItems),
        totalAmount: totalAmount,
      ));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event,
      Emitter<ProductState> emit,
      ) async {
    _cartItems.removeWhere((item) => item.product.id == event.productId);

    final totalAmount = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    emit(CartUpdated(
      cartItems: List.from(_cartItems),
      totalAmount: totalAmount,
    ));
  }

  Future<void> _onClearCart(
      ClearCart event,
      Emitter<ProductState> emit,
      ) async {
    _cartItems.clear();

    emit(CartUpdated(
      cartItems: [],
      totalAmount: 0.0,
    ));
  }

  // Getters
  CafeModel? get currentCafe => _currentCafe;
  List<CartItem> get cartItems => List.from(_cartItems);
  double get cartTotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}