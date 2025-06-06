import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe_product/selecting_choice.dart';

import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../bloc/product_bloc/product_event.dart';
import '../../../../bloc/product_bloc/product_state.dart';
import '../../../../model/product/product_model.dart';
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
  List<ProductCustomization> _customizations = [];

  @override
  void initState() {
    super.initState();
    _initializeCustomizations();
    context.read<ProductBloc>().add(LoadProductDetails(productId: widget.productId));
  }

  void _initializeCustomizations() {
    _customizations = [
      ProductCustomization(
        type: 'Size',
        selectedValue: 'Regular',
        options: ['Regular', 'Small', 'Large'],
      ),
      ProductCustomization(
        type: 'Sugar',
        selectedValue: 'Normal',
        options: ['Less', 'Normal', 'None'],
      ),
      ProductCustomization(
        type: 'Ice',
        selectedValue: 'Normal',
        options: ['Less', 'None', 'Normal'],
      ),
    ];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _updateCustomization(String type, String value) {
    setState(() {
      final index = _customizations.indexWhere((c) => c.type == type);
      if (index != -1) {
        _customizations[index] = _customizations[index].copyWith(selectedValue: value);
      }
    });
  }

  void _addToCart(ProductModel product) {
    if (_counter > 0) {
      context.read<ProductBloc>().add(AddToCart(
        product: product,
        quantity: _counter,
        customizations: _customizations,
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
      });
    }
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
                  _buildCustomizationOptions(),
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
                    Container(
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
                            Icons.share,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildCustomizationOptions() {
    return Column(
      children: _customizations.map((customization) {
        return SelectChoice(
          selecteditem: (String value) {
            _updateCustomization(customization.type, value);
          },
          items: [customization.type, ...customization.options],
          initialSelection: 'Regular',
        );
      }).toList(),
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
                    text2: "multiple locations",size: 14,
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextStyles.textHeadings(
                textValue: '£${product.basePrice}',
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
                      onPressed: _decrementCounter,
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
                      onPressed: _incrementCounter,
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
                    ? 'Add to Cart (£${(product.priceAsDouble * _counter).toStringAsFixed(2)})'
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