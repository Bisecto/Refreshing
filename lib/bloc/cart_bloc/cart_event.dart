abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;
  final List<Map<String, String>> customizations;

  AddToCartEvent({
    required this.productId,
    required this.quantity,
    required this.customizations,
  });
}

class UpdateCartItemEvent extends CartEvent {
  final String itemId;
  final int quantity;

  UpdateCartItemEvent({
    required this.itemId,
    required this.quantity,
  });
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  RemoveCartItemEvent({required this.itemId});
}

class ClearCartEvent extends CartEvent {}

class GetCartCountEvent extends CartEvent {}