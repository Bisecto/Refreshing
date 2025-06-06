import '../../model/cafe/cafe_model.dart';
import '../../model/product/cart_item.dart';
import '../../model/product/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class CafeDetailsLoaded extends ProductState {
  final CafeModel cafe;

  CafeDetailsLoaded({required this.cafe});
}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final Map<String, dynamic> meta;
  final bool hasMore;
  final String cafeId;

  ProductsLoaded({
    required this.products,
    required this.meta,
    required this.hasMore,
    required this.cafeId,
  });
}

class ProductDetailsLoaded extends ProductState {
  final ProductModel product;

  ProductDetailsLoaded({required this.product});
}

class CartUpdated extends ProductState {
  final List<CartItem> cartItems;
  final double totalAmount;

  CartUpdated({
    required this.cartItems,
    required this.totalAmount,
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}

class ProductLoadingMore extends ProductState {
  final List<ProductModel> currentProducts;

  ProductLoadingMore({required this.currentProducts});
}
