import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/cart_model.dart';
import '../../repository/cart_service.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/shared_preferences.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  CartSummaryWithItemsList? _currentCartSummary;

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

  CartSummaryWithItemsList? get currentCartSummary => _currentCartSummary;

  int get itemCount => _currentCartSummary?.itemCount ?? 0;

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final cartResponse = await _cartService.getCart(token: token);

      if (cartResponse.items.isEmpty) {
        _currentCartSummary = null;
        emit(CartEmpty());
      } else {
        _currentCartSummary = CartSummaryWithItemsList(
          itemCount: cartResponse.summary.itemCount,
          total: cartResponse.summary.total,
          items: cartResponse.items,
        );
        emit(CartLoaded(cartSummary: _currentCartSummary!));
      }
    } catch (e) {
      emit(CartError(message: _getErrorMessage(e)));
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
        add(LoadCart());

        emit(CartItemUpdated(message: result['message'] ?? 'Cart updated'));
        // Reload cart to get updated data
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
        add(LoadCart());

        emit(CartItemRemoved(message: result['message'] ?? 'Item removed'));
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
      emit(CartLoading());
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);

      final result = await _cartService.clearCart(token:token );

      if (result['success'] == true) {
        _currentCartSummary = null;
        emit(CartCleared(message: 'Cart cleared successfully'));
        emit(CartEmpty());
      } else {
        emit(CartError(message: result['message'] ?? 'Failed to clear cart'));
      }
    } catch (e) {
      emit(CartError(message: _getErrorMessage(e)));
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

  String _getErrorMessage(dynamic error) {
    if (error.toString().toLowerCase().contains('network') ||
        error.toString().toLowerCase().contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
