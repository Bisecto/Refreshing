import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe_product/selecting_choice.dart';

import '../../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../../bloc/cart_bloc/cart_event.dart';
import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../bloc/product_bloc/product_event.dart';
import '../../../../bloc/product_bloc/product_state.dart';
import '../../../../model/product/product_model.dart';
import '../../../../model/product/customization_model.dart'; // Add this import
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class SingleCafeProduct extends StatefulWidget {
  final String productId;

  const SingleCafeProduct({super.key, required this.productId});

  @override
  State<SingleCafeProduct> createState() => _SingleCafeProductState();
}

class _SingleCafeProductState extends State<SingleCafeProduct> {
  int _counter = 0;
  Map<String, String> _selectedCustomizations = {}; // Changed to Map for easier management
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductDetails(productId: widget.productId));
  }

  void _initializeCustomizations(List<CustomizationModel> customizations) {
    _selectedCustomizations.clear();

    for (final customization in customizations) {
      if (customization.isAvailable == true && customization.options.isNotEmpty) {
        // Find default option or use first available option
        Option? defaultOption;

        // First try to find a default option
        for (final option in customization.options) {
          if (option is Option && option.isDefault == true && option.isAvailable == true) {
            defaultOption = option;
            break;
          }
        }

        // If no default found, use first available option
        if (defaultOption == null) {
          for (final option in customization.options) {
            if (option is Option && option.isAvailable == true) {
              defaultOption = option;
              break;
            }
          }
        }

        // Set the selected customization
        if (defaultOption != null && customization.id != null) {
          _selectedCustomizations[customization.id!] = defaultOption.id!;
        }
      }
    }
  }

  double _calculateTotalPrice(ProductModel product) {
    double total = product.priceAsDouble;

    // Add price modifiers from selected customizations
    for (final customization in product.customizations ?? <CustomizationModel>[]) {
      final selectedOptionId = _selectedCustomizations[customization.id];
      if (selectedOptionId != null) {
        for (final option in customization.options) {
          if (option is Option && option.id == selectedOptionId) {
            final priceModifier = double.tryParse(option.priceModifier ?? '0') ?? 0.0;
            total += priceModifier;
            break;
          }
        }
      }
    }

    return total * _counter;
  }

  void _incrementCounter(ProductModel product) {
    setState(() {
      _counter++;
      _totalPrice = _calculateTotalPrice(product);
    });
  }

  void _decrementCounter(ProductModel product) {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _totalPrice = _calculateTotalPrice(product);
      }
    });
  }

  void _updateCustomization(String customizationId, String optionId, ProductModel product) {
    setState(() {
      _selectedCustomizations[customizationId] = optionId;
      _totalPrice = _calculateTotalPrice(product);
    });
  }

  bool _validateRequiredCustomizations(List<CustomizationModel> customizations) {
    for (final customization in customizations) {
      if (customization.isRequired == true && customization.isAvailable == true) {
        if (!_selectedCustomizations.containsKey(customization.id) ||
            _selectedCustomizations[customization.id] == null) {
          return false;
        }
      }
    }
    return true;
  }

  void _addToCart(ProductModel product) {
    if (_counter <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select quantity'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate required customizations
    if (!_validateRequiredCustomizations(product.customizations ?? [])) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required customizations'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert selected customizations to API format - array of objects
    final customizationsList = <Map<String, String>>[];

    for (final customization in product.customizations ?? <CustomizationModel>[]) {
      final selectedOptionId = _selectedCustomizations[customization.id];
      if (selectedOptionId != null && customization.id != null) {
        customizationsList.add({
          'customizationId': customization.id!,
          'optionId': selectedOptionId,
        });
      }
    }

    // Use CartBloc to add to cart via API
    context.read<CartBloc>().add(AddToCartEvent(
      productId: product.id,
      quantity: _counter,
      customizations: customizationsList, // Send as array instead of map
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _counter = 0;
      _totalPrice = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            ProductModel? product;
            if (state is ProductDetailsLoaded) {
              product = state.product;

              // Initialize customizations when product is loaded
              if (product.customizations != null && _selectedCustomizations.isEmpty) {
                _initializeCustomizations(product.customizations!);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _totalPrice = _calculateTotalPrice(product!);
                  });
                });
              }
            }

            if (product == null) {
              return const Center(
                child: Text('Product not found'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(product),
                  _buildProductInfo(product),
                  _buildProductDescription(product),
                  _buildProductRating(product),
                  _buildCustomizationOptions(product),
                  _buildAvailableLocations(),
                  _buildAddToCartSection(product),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductHeader(ProductModel product) {
    return Container(
      height: 350,
      width: AppUtils.deviceScreenSize(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: product.primaryImageUrl.isNotEmpty
              ? NetworkImage(product.primaryImageUrl)
              : const NetworkImage(
            'https://via.placeholder.com/350x350/f0f0f0/999999?text=No+Image',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 350,
        width: AppUtils.deviceScreenSize(context).width,
        color: AppColors.black.withOpacity(0.5),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: TextStyles.textHeadings(
                          textValue: product.name,
                          textSize: 20,
                          textColor: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox()
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.black.withOpacity(0.5),
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   child: const Center(
                    //     child: Padding(
                    //       padding: EdgeInsets.all(10.0),
                    //       child: Icon(
                    //         Icons.share,
                    //         color: AppColors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
          child: TextStyles.textHeadings(
            textValue: product.name,
            textSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
          child: Row(
            children: [
              CustomText(
                text: product.category.name,
                size: 16,
                color: AppColors.textColor,
              ),
              const SizedBox(width: 5),
              if (product.isAvailable)
                const CustomText(
                  text: 'Available',
                  size: 16,
                  color: Colors.green,
                )
              else
                const CustomText(
                  text: 'Unavailable',
                  size: 16,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductDescription(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
          child: TextStyles.textHeadings(
            textValue: 'Description',
            textSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
          child: TextStyles.textDetails(
            textValue: product.description,
            textSize: 16,
            textColor: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProductRating(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < product.averageRating.floor()
                    ? AppColors.yellow
                    : AppColors.grey,
                size: 15,
              );
            }),
          ),
          const SizedBox(width: 8),
          CustomText(
            text: "(${product.totalReviews})",
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationOptions(ProductModel product) {
    final customizations = product.customizations ?? <CustomizationModel>[];

    if (customizations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 10),
          child: TextStyles.textHeadings(
            textValue: 'Customizations',
            textSize: 18,
          ),
        ),
        ...customizations.where((c) => c.isAvailable == true).map((customization) {
          return _buildCustomizationSection(customization, product);
        }).toList(),
      ],
    );
  }

  Widget _buildCustomizationSection(CustomizationModel customization, ProductModel product) {
    final selectedOptionId = _selectedCustomizations[customization.id];
    final availableOptions = customization.options
        .where((option) => option is Option && option.isAvailable == true)
        .cast<Option>()
        .toList();

    if (availableOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextStyles.textSubHeadings(
                textValue: customization.name ?? '',
                textSize: 16,
              ),
              if (customization.isRequired == true) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          ...availableOptions.map((option) {
            final isSelected = selectedOptionId == option.id;
            final priceModifier = double.tryParse(option.priceModifier ?? '0') ?? 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => _updateCustomization(customization.id!, option.id!, product),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.black.withOpacity(0.1) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.black : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.black : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.name ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (priceModifier != 0) ...[
                        Text(
                          '${priceModifier > 0 ? '+' : ''}£${priceModifier.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: priceModifier > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAvailableLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.blue[700]),
                  TextStyles.richTexts(
                    text1: 'Available at ',
                    text2: "multiple locations",
                    size: 14,
                    color2: Colors.blue[700],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 15, 0, 0),
                    child: Container(
                      height: 35,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextStyles.textSubHeadings(
                          textValue: '30% off',
                          textColor: AppColors.white,
                          textSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextStyles.textHeadings(
                textValue: 'Available Locations',
                textSize: 20,
              ),
              SvgPicture.asset(AppIcons.tag),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection(ProductModel product) {
    final basePrice = product.priceAsDouble;
    final customizationPrice = _totalPrice > 0 ? (_totalPrice / _counter) - basePrice : 0.0;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Price breakdown
          if (_counter > 0 && customizationPrice > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Price:'),
                      Text('£${basePrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Customizations:'),
                      Text('£${customizationPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price per item:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('£${(basePrice + customizationPrice).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextStyles.textHeadings(
                textValue: _counter > 0
                    ? '£${_totalPrice.toStringAsFixed(2)}'
                    : '£${basePrice.toStringAsFixed(2)}',
                textSize: 24,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrementCounter(product),
                      color: Colors.white,
                      iconSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextStyles.textHeadings(
                      textValue: '$_counter',
                      textSize: 20,
                      textColor: AppColors.black,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _incrementCounter(product),
                      color: Colors.white,
                      iconSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _counter > 0 ? () => _addToCart(product) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextStyles.textHeadings(
                textValue: _counter > 0
                    ? 'Add to Cart (£${_totalPrice.toStringAsFixed(2)})'
                    : 'Add to Cart',
                textSize: 16,
                textColor: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}