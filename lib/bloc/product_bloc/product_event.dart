// lib/blocs/product/product_event.dart
import 'package:refreshing_co/model/product/customization_model.dart';

import '../../model/product/product_model.dart';

abstract class ProductEvent {}

class LoadCafeDetails extends ProductEvent {
  final String cafeId;

  LoadCafeDetails({required this.cafeId});
}



class LoadMoreProducts extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final String productId;

  LoadProductDetails({required this.productId});
}
class AddToCartFromProduct extends ProductEvent {
  final ProductModel product;
  final int quantity;
  final List<CustomizationModel> customizations;
  final String? specialInstructions;

  AddToCartFromProduct({
    required this.product,
    required this.quantity,
    required this.customizations,
    this.specialInstructions,
  });
}
// class AddToCart extends ProductEvent {
//   final ProductModel product;
//   final int quantity;
//   final List<ProductCustomization> customizations;
//   final String? specialInstructions;
//
//   AddToCart({
//     required this.product,
//     required this.quantity,
//     required this.customizations,
//     this.specialInstructions,
//   });
// }
//
// class UpdateCartItemQuantity extends ProductEvent {
//   final String productId;
//   final int quantity;
//
//   UpdateCartItemQuantity({
//     required this.productId,
//     required this.quantity,
//   });
// }
//
// class RemoveFromCart extends ProductEvent {
//   final String productId;
//
//   RemoveFromCart({required this.productId});
// }

class ClearCart extends ProductEvent {}
// Enhanced LoadProducts event with optional parameters
class LoadProducts extends ProductEvent {
  final String cafeId;
  final int page;
  final int limit;
  final String? category;
  final String? search;
  final bool? isAvailable;

  LoadProducts({
    required this.cafeId,
    this.page = 1,
    this.limit = 10,
    this.category,
    this.search,
    this.isAvailable,
  });
}

