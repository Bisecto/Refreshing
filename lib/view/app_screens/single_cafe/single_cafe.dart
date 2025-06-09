import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe_product/single_cafe_product.dart';
import 'package:refreshing_co/view/important_pages/dialog_box.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../bloc/cart_bloc/cart_bloc.dart';
import '../../../bloc/cart_bloc/cart_event.dart';
import '../../../bloc/product_bloc/product_bloc.dart';
import '../../../bloc/product_bloc/product_event.dart';
import '../../../bloc/product_bloc/product_state.dart';
import '../../../model/cafe/cafe_model.dart';
import '../../../model/product/product_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/loading_animation.dart';

class SingleCafe extends StatefulWidget {
  final String cafeId;

  const SingleCafe({super.key, required this.cafeId});

  @override
  State<SingleCafe> createState() => _SingleCafeState();
}

class _SingleCafeState extends State<SingleCafe> {
  final ScrollController _scrollController = ScrollController();

  // final Map<String, int> _productCounters = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeData() {
    context.read<ProductBloc>().add(LoadCafeDetails(cafeId: widget.cafeId));
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more products when user is near the bottom
        context.read<ProductBloc>().add(LoadMoreProducts());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _incrementCounter(String productId) {
  //   setState(() {
  //     _productCounters[productId] = (_productCounters[productId] ?? 0) + 1;
  //   });
  // }
  //
  // void _decrementCounter(String productId) {
  //   setState(() {
  //     final currentCount = _productCounters[productId] ?? 0;
  //     if (currentCount > 0) {
  //       _productCounters[productId] = currentCount - 1;
  //     }
  //   });
  // }
  //
  // int _getCounter(String productId) {
  //   return _productCounters[productId] ?? 0;
  // }

  // void _addToCart(ProductModel product) {
  //   //final quantity = _getCounter(product.id);
  //   //if (quantity > 0) {
  //   context.read<CartBloc>().add(AddToCartEvent(
  //     productId: product.id,
  //     quantity: 1,
  //     customizations: [{}],
  //   ));
  //   MSG.snackBar(context, '${product.name} added to cart');
  //
  //   // Reset counter after adding to cart
  //   // setState(() {
  //   //   _productCounters[product.id] = 0;
  //   // });
  //   // }
  // }

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
          } else if (state is CartUpdated) {
            // Handle cart updates if needed
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            CafeModel? cafe;
            List<ProductModel> products = [];
            bool isLoading = true;
            bool hasMore = false;

            if (state is CafeDetailsLoaded) {
              cafe = state.cafe;
              isLoading = false;
            } else if (state is ProductsLoaded) {
              cafe = context.read<ProductBloc>().currentCafe;
              products = state.products;
              hasMore = state.hasMore;
              isLoading = false;
            } else if (state is ProductLoadingMore) {
              cafe = context.read<ProductBloc>().currentCafe;
              products = state.currentProducts;
              isLoading = false;
            } else if (state is ProductLoading) {
              cafe = context.read<ProductBloc>().currentCafe;
              isLoading = true;
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCafeHeader(cafe),

                  if (cafe != null) ...[
                    _buildCafeInfo(cafe),
                    _buildCafeDescription(cafe),
                    _buildCafeRating(cafe),
                    //_buildCafeStats(cafe),
                  ],

                  _buildMenuHeader(),

                  if (isLoading && products.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: LoadingDialog(
                          "Fetching cafes",
                          color: AppColors.appMainColor,
                        ),
                      ),
                    )
                  else if (products.isEmpty)
                    _buildEmptyProductsState()
                  else
                    _buildProductsList(products, hasMore),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCafeHeader(CafeModel? cafe) {
    return Container(
      height: 350,
      width: AppUtils.deviceScreenSize(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              cafe?.primaryImageUrl.isNotEmpty == true
                  ? NetworkImage(cafe!.primaryImageUrl)
                  : const AssetImage(AppImages.singleProduct) as ImageProvider,
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
                padding: const EdgeInsets.all(15.0),
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
                          textValue: cafe?.name ?? 'Loading...',
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
                          child: Icon(Icons.share, color: AppColors.white),
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

  Widget _buildCafeInfo(CafeModel cafe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
          child: TextStyles.textHeadings(textValue: cafe.name, textSize: 20),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.black),
              Expanded(child: CustomText(text: cafe.displayLocation, size: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCafeDescription(CafeModel cafe) {
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
            textValue: cafe.description,
            textSize: 16,
            textColor: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCafeRating(CafeModel cafe) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color:
                    index < cafe.averageRating.floor()
                        ? AppColors.yellow
                        : AppColors.grey,
                size: 15,
              );
            }),
          ),
          const SizedBox(width: 8),
          CustomText(text: "(${cafe.totalReviews})"),
        ],
      ),
    );
  }

  // Widget _buildCafeStats(CafeModel cafe) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(
  //           children: [
  //             TextStyles.textHeadings(textValue: '${cafe.categories.length}  ', textSize: 20),
  //             TextStyles.textSubHeadings(
  //               textValue: 'Categories available',
  //               textSize: 16,
  //               textColor: AppColors.textColor,
  //             ),
  //           ],
  //         ),
  //         if (cafe.hasDiscount)
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(5.0, 15, 0, 0),
  //                 child: Container(
  //                   height: 40,
  //                   width: 100,
  //                   decoration: BoxDecoration(
  //                     color: AppColors.black,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Center(
  //                     child: TextStyles.textSubHeadings(
  //                       textValue: '30% off',
  //                       textColor: AppColors.white,
  //                       textSize: 16,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMenuHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextStyles.textHeadings(textValue: 'Menu', textSize: 20),
          SvgPicture.asset(AppIcons.tag),
        ],
      ),
    );
  }

  Widget _buildEmptyProductsState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            TextStyles.textHeadings(
              textValue: 'No menu items available',
              textSize: 18,
              textColor: AppColors.textColor,
            ),
            const SizedBox(height: 8),
            TextStyles.textDetails(
              textValue: 'Check back later for updates',
              textSize: 14,
              textColor: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<ProductModel> products, bool hasMore) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];
              return _buildMenuContainer(product);
            },
          ),
        ),
        if (hasMore)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildMenuContainer(ProductModel product) {
    // final counter = _getCounter(product.id);

    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 0, 0, 10),
      child: GestureDetector(
        onTap: () {
          AppNavigator.pushAndStackPage(
            context,
            page: SingleCafeProduct(productId: product.id),
          );
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product Name
                      TextStyles.textHeadings(
                        textValue: product.name,
                        textSize: 15,
                      ),

                      // Product Description
                      SizedBox(
                        width: AppUtils.deviceScreenSize(context).width / 2,
                        child: TextStyles.textDetails(
                          textValue: product.description,
                          textColor: AppColors.textColor,
                          textSize: 13,
                        ),
                      ),

                      // Rating
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: AppUtils.deviceScreenSize(context).width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        color:
                                            index <
                                                    product.averageRating
                                                        .floor()
                                                ? AppColors.yellow
                                                : AppColors.grey,
                                        size: 15,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(text: "(${product.totalReviews})"),
                                ],
                              ),
                              TextStyles.textHeadings(
                                textValue: '£${product.basePrice}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),

                Container(
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image:
                          product.primaryImageUrl.isNotEmpty
                              ? NetworkImage(product.primaryImageUrl)
                              : const NetworkImage(
                                'https://via.placeholder.com/115x115/f0f0f0/999999?text=No+Image',
                              ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
