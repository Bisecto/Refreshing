// lib/blocs/product/product_event.dart
import '../../model/product/product_model.dart';

abstract class ProductEvent {}

class LoadCafeDetails extends ProductEvent {
  final String cafeId;

  LoadCafeDetails({required this.cafeId});
}

class LoadProducts extends ProductEvent {
  final String cafeId;
  final int page;
  final int limit;

  LoadProducts({
    required this.cafeId,
    this.page = 1,
    this.limit = 10,
  });
}

class LoadMoreProducts extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final String productId;

  LoadProductDetails({required this.productId});
}

class AddToCart extends ProductEvent {
  final ProductModel product;
  final int quantity;
  final List<ProductCustomization> customizations;
  final String? specialInstructions;

  AddToCart({
    required this.product,
    required this.quantity,
    required this.customizations,
    this.specialInstructions,
  });
}

class UpdateCartItemQuantity extends ProductEvent {
  final String productId;
  final int quantity;

  UpdateCartItemQuantity({
    required this.productId,
    required this.quantity,
  });
}

class RemoveFromCart extends ProductEvent {
  final String productId;

  RemoveFromCart({required this.productId});
}

class ClearCart extends ProductEvent {}