import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/cart_model.dart';
import '../../repository/cart_service.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/shared_preferences.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  CartSummary? _currentCartSummary;

  CartBloc({required CartService cartService})
    : _cartService = cartService,
      super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
    on<GetCartCountEvent>(_onGetCartCount);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.getCart(token: token);

      if (result['success'] == true) {
        final cartItems = result['data'] as List<CartItemModel>;
        _currentCartSummary = CartSummary.fromItems(cartItems);
        emit(CartLoaded(cartSummary: _currentCartSummary!));
      } else {
        emit(CartError(message: result['message'] ?? 'Failed to load cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.addToCart(
        productId: event.productId,
        quantity: event.quantity,
        customizations: event.customizations,
        token: token,
      );
print(token);
print(result);
print(result);
print(result);
print(result);
      if (result['success'] == true) {
        emit(CartItemAdded(message: result['message'] ?? 'Item added to cart'));
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(
          CartError(message: result['message'] ?? 'Failed to add item to cart'),
        );
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.updateCartItem(
        itemId: event.itemId,
        quantity: event.quantity,
        token: token,
      );

      if (result['success'] == true) {
        emit(CartItemUpdated(message: result['message'] ?? 'Cart updated'));
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(CartError(message: result['message'] ?? 'Failed to update cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  Future<void> _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.removeCartItem(
        event.itemId,
        token: token,
      );

      if (result['success'] == true) {
        emit(CartItemRemoved(message: result['message'] ?? 'Item removed'));
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(CartError(message: result['message'] ?? 'Failed to remove item'));
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.clearCart(token: token);

      if (result['success'] == true) {
        _currentCartSummary = CartSummary.fromItems([]);
        emit(CartCleared(message: result['message'] ?? 'Cart cleared'));
        emit(CartLoaded(cartSummary: _currentCartSummary!));
      } else {
        emit(CartError(message: result['message'] ?? 'Failed to clear cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  Future<void> _onGetCartCount(
    GetCartCountEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.getCartCount(token: token);

      if (result['success'] == true) {
        emit(CartCountLoaded(count: result['count'] ?? 0));
      } else {
        emit(
          CartError(message: result['message'] ?? 'Failed to get cart count'),
        );
      }
    } catch (e) {
      emit(CartError(message: 'Network error occurred'));
    }
  }

  // Getters
  CartSummary? get currentCartSummary => _currentCartSummary;

  bool get hasItems => _currentCartSummary?.items.isNotEmpty ?? false;

  int get itemCount => _currentCartSummary?.itemCount ?? 0;

  double get totalAmount => _currentCartSummary?.total ?? 0.0;
}
