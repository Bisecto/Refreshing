import 'package:refreshing_co/model/product/customization_model.dart';
import 'package:refreshing_co/model/product/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  final List<CustomizationModel> customizations;
  final String? specialInstructions;

  CartItem({
    required this.product,
    required this.quantity,
    required this.customizations,
    this.specialInstructions,
  });

  double get totalPrice => product.priceAsDouble * quantity;

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    List<CustomizationModel>? customizations,
    String? specialInstructions,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
