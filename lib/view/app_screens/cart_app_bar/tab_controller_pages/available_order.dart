// lib/view/app_screens/available_order/available_order.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../bloc/cart_bloc/cart_event.dart';
import '../../../../bloc/cart_bloc/cart_state.dart';
import '../../../../bloc/product_bloc/product_event.dart';
import '../../../../model/cart_model.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_input.dart';
import 'order_details.dart';


class AvailableOrder extends StatefulWidget {
  final Function(int) onPageChanged;

  const AvailableOrder({super.key, required this.onPageChanged});

  @override
  State<AvailableOrder> createState() => _AvailableOrderState();
}

class _AvailableOrderState extends State<AvailableOrder> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load cart when widget initializes
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to clear all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(ClearCartEvent());
                Navigator.of(context).pop();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Order Placed!'),
            ],
          ),
          content: const Text('Your order has been placed successfully. You will receive a confirmation shortly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear cart after successful order
                context.read<CartBloc>().add(ClearCartEvent());
                // Navigate back to menu
                widget.onPageChanged(0);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CartItemRemoved || state is CartItemUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state is CartItemRemoved
                    ? (state as CartItemRemoved).message
                    : (state as CartItemUpdated).message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CartCleared) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            CartSummary? cartSummary;
            if (state is CartLoaded) {
              cartSummary = state.cartSummary;
            } else {
              cartSummary = context.read<CartBloc>().currentCartSummary;
            }

            if (cartSummary == null || cartSummary.isEmpty) {
              return _buildEmptyCartState();
            }

            return _buildCartContent(cartSummary);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: AppColors.grey,
          ),
          const SizedBox(height: 24),
          TextStyles.textHeadings(
            textValue: 'Your cart is empty',
            textSize: 24,
            textColor: AppColors.black,
          ),
          const SizedBox(height: 12),
          TextStyles.textDetails(
            textValue: 'Add some delicious items to your cart to get started!',
            textSize: 16,
            textColor: AppColors.textColor,
          ),
          const SizedBox(height: 40),
          FormButton(
            onPressed: () {
              widget.onPageChanged(0);
            },
            text: "Explore Menu",
            bgColor: AppColors.appMainColor,
            textColor: AppColors.white,
            weight: FontWeight.bold,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartSummary cartSummary) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildSearchBar(),

          const SizedBox(height: 20),

          // Cart Items
          Expanded(
            child: _buildCartItems(cartSummary.items),
          ),

          const SizedBox(height: 20),

          // Order Summary
         // _buildOrderSummary(cartSummary),

          const SizedBox(height: 20),

          // Action Buttons
          _buildActionButtons(cartSummary),
        ],
      ),
    );
  }


  Widget _buildSearchBar() {
    return CustomTextFormField(
      controller: searchController,
      hint: 'Search cart items...',
      label: '',
      backgroundColor: AppColors.grey,
      widget: const Icon(Icons.search),
    );
  }

  Widget _buildCartItems(List<CartItemModel> items) {
    return ListView.builder(
      itemCount: items.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCartItemContainer(item, index);
      },
    );
  }

  // Widget _buildCartItemContainer(CartItemModel item, int index) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: AppColors.grey.withOpacity(0.2),
  //       border: Border.all(width: 1, color: AppColors.grey.withOpacity(0.3)),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             // Product Image
  //             Container(
  //               width: 60,
  //               height: 60,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8),
  //                 image: DecorationImage(
  //                   image: item.productImage.isNotEmpty
  //                       ? NetworkImage(item.productImage)
  //                       : AssetImage(AppImages.coffe) as ImageProvider,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //
  //             const SizedBox(width: 12),
  //
  //             // Product Details
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   TextStyles.textHeadings(
  //                     textValue: item.productName,
  //                     textSize: 16,
  //                   ),
  //                   //if (item.customizationDisplay.isNotEmpty)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 4),
  //                       child: CustomText(
  //                         text: "${item.quantity} item ",
  //                         size: 12,
  //                         color: AppColors.textColor,
  //                       ),
  //                     ),
  //                   TextStyles.textHeadings(
  //                     textValue: '£${item.totalPrice.toStringAsFixed(2)}',
  //                     textSize: 16,
  //                     textColor: AppColors.appMainColor,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             // Quantity Controls
  //            // _buildQuantityControls(item),
  //           ],
  //         ),
  //         FormButton(
  //           onPressed: () {
  //             Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => CartItemDetailsPage(cartItem: item),
  //               ),
  //             );            },
  //           text: "View details",
  //           bgColor: AppColors.appMainColor,
  //           textColor: AppColors.white,
  //           weight: FontWeight.bold,
  //           borderRadius: 12,
  //           height: 40,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildCartItemContainer(CartItemModel item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.2),
        border: Border.all(width: 1, color: AppColors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: item.productImage.isNotEmpty
                        ? NetworkImage(item.productImage)
                        : AssetImage(AppImages.coffe) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextStyles.textHeadings(
                            textValue: item.productName,
                            textSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CustomText(
                        text: _getCustomizationSummary(item),
                        size: 12,
                        color: AppColors.textColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          CustomText(
                            text: "${item.quantity} item${item.quantity > 1 ? 's' : ''} • ",
                            size: 12,
                            color: AppColors.textColor,
                          ),
                          TextStyles.textHeadings(
                            textValue: '£${item.totalPrice}',
                            textSize: 16,
                            textColor: AppColors.appMainColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Quick quantity controls (optional)
              _buildQuickQuantityControls(item),
            ],
          ),


          FormButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartItemDetailsPage(cartItem: item),
                ),
              );
            },
            text: "View details",
            bgColor: AppColors.appMainColor,
            textColor: AppColors.white,
            weight: FontWeight.bold,
            borderRadius: 12,
            height: 40,
          ),
        ],
      ),
    );
  }

// Add these helper methods to your _AvailableOrderState class:

  String _getCustomizationSummary(CartItemModel item) {
    if (item.customizations.isEmpty) return 'No customizations';

    List<String> summaryParts = [];

    // Try to find size and milk type first as they're most important
    String? size;
    String? milkType;

    for (final entry in item.customizations.entries) {
      final customization = entry.value;
      final type = (customization['customizationType'] as String?)?.toLowerCase();

      if (type == 'size') {
        size = customization['optionName'] as String?;
      } else if (type == 'milk') {
        milkType = customization['optionName'] as String?;
      }
    }

    if (size != null) summaryParts.add('Size: $size');
    if (milkType != null) summaryParts.add('$milkType');

    // If we have space, add one more customization
    if (summaryParts.length < 2) {
      for (final entry in item.customizations.entries) {
        final customization = entry.value;
        final type = (customization['customizationType'] as String?)?.toLowerCase();

        if (type != 'size' && type != 'milk') {
          summaryParts.add('${customization['optionName']}');
          break;
        }
      }
    }

    return summaryParts.take(2).join(' • ');
  }

  Widget _buildQuickQuantityControls(CartItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(UpdateCartItemEvent(
                  itemId: item.id,
                  quantity: item.quantity - 1,
                ));
              } else {
                _showRemoveItemDialog(item);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                item.quantity > 1 ? Icons.remove : Icons.delete_outline,
                size: 16,
                color: item.quantity > 1 ? AppColors.black : Colors.red,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: TextStyles.textHeadings(
              textValue: '${item.quantity}',
              textSize: 14,
            ),
          ),

          GestureDetector(
            onTap: () {
              context.read<CartBloc>().add(UpdateCartItemEvent(
                itemId: item.id,
                quantity: item.quantity + 1,
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.add,
                size: 16,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(CartItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text('Are you sure you want to remove ${item.productName} from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(RemoveCartItemEvent(
                  itemId: item.id,
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  // Widget _buildQuantityControls(CartItemModel item) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: AppColors.grey.withOpacity(0.3)),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             if (item.quantity > 1) {
  //               context.read<CartBloc>().add(UpdateCartItemEvent(
  //                 itemId: item.id,
  //                 quantity: item.quantity - 1,
  //               ));
  //             } else {
  //               context.read<CartBloc>().add(RemoveCartItemEvent(itemId: item.id));
  //             }
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(8),
  //             child: Icon(
  //               item.quantity > 1 ? Icons.remove : Icons.delete_outline,
  //               size: 18,
  //               color: item.quantity > 1 ? AppColors.black : Colors.red,
  //             ),
  //           ),
  //         ),
  //
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: TextStyles.textHeadings(
  //             textValue: '${item.quantity}',
  //             textSize: 16,
  //           ),
  //         ),
  //
  //         GestureDetector(
  //           onTap: () {
  //             context.read<CartBloc>().add(UpdateCartItemEvent(
  //               itemId: item.id,
  //               quantity: item.quantity + 1,
  //             ));
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(8),
  //             child: const Icon(
  //               Icons.add,
  //               size: 18,
  //               color: AppColors.black,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildOrderSummary(CartSummary cartSummary) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.grey.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: AppColors.grey.withOpacity(0.2)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextStyles.textHeadings(
  //           textValue: 'Order Summary',
  //           textSize: 18,
  //         ),
  //         const SizedBox(height: 12),
  //
  //         // Subtotal
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const CustomText(
  //               text: "Subtotal",
  //               color: AppColors.textColor,
  //               size: 15,
  //             ),
  //             TextStyles.richTexts(
  //               text1: '£',
  //               size: 15,
  //               color: AppColors.black,
  //               text2: ' ${cartSummary.subtotal.toStringAsFixed(2)}',
  //               color2: AppColors.textColor,
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 8),
  //
  //         // Tax
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const CustomText(
  //               text: "Tax",
  //               color: AppColors.textColor,
  //               size: 15,
  //             ),
  //             TextStyles.richTexts(
  //               text1: '£',
  //               size: 15,
  //               color: AppColors.black,
  //               text2: ' ${cartSummary.tax.toStringAsFixed(2)}',
  //               color2: AppColors.textColor,
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 12),
  //         const Divider(),
  //         const SizedBox(height: 8),
  //
  //         // Total
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextStyles.textHeadings(
  //               textValue: 'Total',
  //               textSize: 18,
  //             ),
  //             TextStyles.richTexts(
  //               text1: '£',
  //               size: 18,
  //               color: AppColors.black,
  //               text2: ' ${cartSummary.total.toStringAsFixed(2)}',
  //               color2: AppColors.black,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionButtons(CartSummary cartSummary) {
    return Column(
      children: [
        // Order Now Button
        // FormButton(
        //   onPressed: () {
        //     _showOrderSuccessDialog();
        //   },
        //   text: "Order Now (£${cartSummary.total.toStringAsFixed(2)})",
        //   bgColor: AppColors.appMainColor,
        //   textColor: AppColors.white,
        //   weight: FontWeight.bold,
        //   borderRadius: 12,
        //   height: 56,
        // ),

        const SizedBox(height: 12),

        // Continue Shopping Button
        FormButton(
          onPressed: () {
            widget.onPageChanged(0);
          },
          text: "Explore menu",
          bgColor: AppColors.grey.withOpacity(0.3),
          textColor: AppColors.black,
          weight: FontWeight.w600,
          borderRadius: 12,
          height: 48,
        ),
      ],
    );
  }
}








class CartBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const CartBadge({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          child,
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;

              if (state is CartLoaded) {
                itemCount = state.cartSummary.itemCount;
              } else {
                itemCount = context.read<CartBloc>().itemCount;
              }

              if (itemCount == 0) {
                return const SizedBox.shrink();
              }

              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    itemCount > 99 ? '99+' : itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}