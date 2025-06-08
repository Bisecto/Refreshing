import '../../model/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartSummary cartSummary;

  CartLoaded({required this.cartSummary});
}

class CartCountLoaded extends CartState {
  final int count;

  CartCountLoaded({required this.count});
}

class CartItemAdded extends CartState {
  final String message;

  CartItemAdded({required this.message});
}

class CartItemUpdated extends CartState {
  final String message;

  CartItemUpdated({required this.message});
}

class CartItemRemoved extends CartState {
  final String message;

  CartItemRemoved({required this.message});
}

class CartCleared extends CartState {
  final String message;

  CartCleared({required this.message});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}