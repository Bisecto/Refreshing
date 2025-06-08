import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../bloc/cart_bloc/cart_event.dart';
import '../../../../bloc/cart_bloc/cart_state.dart';
import '../../../../model/cart_model.dart';
import '../../../../res/app_images.dart';

class CartItemDetailsPage extends StatefulWidget {
  final CartItemModel cartItem;

  const CartItemDetailsPage({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  State<CartItemDetailsPage> createState() => _CartItemDetailsPageState();
}

class _CartItemDetailsPageState extends State<CartItemDetailsPage> {
  late int _quantity;
  late CartItemModel _currentItem;

  @override
  void initState() {
    super.initState();
    _quantity = widget.cartItem.quantity;
    _currentItem = widget.cartItem;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
    _updateCartItemQuantity();
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      _updateCartItemQuantity();
    }
  }

  void _updateCartItemQuantity() {
    context.read<CartBloc>().add(UpdateCartItemEvent(
      itemId: _currentItem.id,
      quantity: _quantity,
    ));
  }

  void _removeFromCart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: Text('Are you sure you want to remove ${_currentItem.productName} from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(RemoveCartItemEvent(
                  itemId: _currentItem.id,
                ));
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to cart
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addMoreItems() {
    // Navigate back to product details to add more
    Navigator.of(context).pop();
    // You can add navigation to product details here if needed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to menu to add more items'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  double get _itemPrice {
    return double.tryParse(_currentItem.totalPrice.toString()) ?? 0.0;
  }

  double get _unitPrice {
    return _itemPrice / _currentItem.quantity;
  }

  double get _totalPrice {
    return _unitPrice * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CartItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProductSection(),
                    _buildCustomizationsSection(),
                    _buildPricingSection(),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Order #230',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Share functionality
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.share, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cafe name
          Text(
            'ROBOT BARISTA BAR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),

          // Product card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                // Product image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: _currentItem.productImage.isNotEmpty
                          ? NetworkImage(_currentItem.productImage)
                          : AssetImage(AppImages.coffe) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentItem.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_currentItem.customizations.isNotEmpty)
                        Text(
                          _getMainCustomization(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '£${_unitPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity controls
                Row(
                  children: [
                    GestureDetector(
                      onTap: _decrementQuantity,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: _quantity > 1 ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),

                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: _incrementQuantity,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationsSection() {
    if (_currentItem.customizations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customizations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ..._currentItem.customizations.entries.map((entry) {
            final customization = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    customization['customizationName'] ?? 'Customization',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        customization['optionName'] ?? 'Option',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if ((customization['priceModifier'] as num?) != 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${(customization['priceModifier'] as num?) != null && (customization['priceModifier'] as num?)! > 0 ? '+' : ''}£${((customization['priceModifier'] as num?) ?? 0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: (customization['priceModifier'] as num?) != null && (customization['priceModifier'] as num?)! > 0
                                ? Colors.green.shade600
                                : Colors.red.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          _buildPriceRow('Items', '$_quantity'),
          const SizedBox(height: 8),
          _buildPriceRow('Subtotal', '£${_totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow('Tax', '£1.00'),
          const SizedBox(height: 8),
          _buildPriceRow('Discount', '£0.00'),

          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),

          _buildPriceRow(
            'Total',
            '£${(_totalPrice + 1.00).toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Add more button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _addMoreItems,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add more'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Continue button
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to cart
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Remove item button
          TextButton(
            onPressed: _removeFromCart,
            child: Text(
              'Remove from cart',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMainCustomization() {
    if (_currentItem.customizations.isEmpty) return '';

    // Try to find size first
    for (final entry in _currentItem.customizations.entries) {
      final customization = entry.value;
      if ((customization['customizationType'] as String?)?.toLowerCase() == 'size') {
        return 'Size: ${customization['optionName']}';
      }
    }

    // If no size, return first customization
    final firstCustomization = _currentItem.customizations.values.first;
    return '${firstCustomization['customizationName']}: ${firstCustomization['optionName']}';
  }
}