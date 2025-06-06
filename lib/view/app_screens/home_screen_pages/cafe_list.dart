// lib/view/app_screens/cafe_list/cafe_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/single_cafe/single_cafe.dart';

import '../../../../res/app_colors.dart';
import '../../../bloc/cafe_bloc/cafe_bloc.dart';
import '../../../bloc/cafe_bloc/cafe_event.dart';
import '../../../bloc/cafe_bloc/cafe_state.dart';
import '../../../model/cafe/adons.dart';
import '../../../model/cafe/cafe_model.dart';
import '../../../model/cafe/category_model.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/filtering_item.dart';
import '../../widgets/form_input.dart';

import 'filtering_items.dart';

class CafeList extends StatefulWidget {
  const CafeList({super.key});

  @override
  State<CafeList> createState() => _CafeListState();
}

class _CafeListState extends State<CafeList> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  bool isSearchActive = false;
  String _currentSearchQuery = '';

  // Filter selections
  String? _selectedCategoryId;
  String? _selectedLocation;
  PriceRangeModel? _selectedPriceRange;
  double? _selectedMinRating;
  String _selectedSortBy = 'relevance';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeData() {
    // Load filter options first
    context.read<CafeBloc>().add(LoadFilterOptions());

    // Load initial cafes with default search
    context.read<CafeBloc>().add(SearchCafes(
      request: CafeSearchRequest(
        limit: 20,
        sortBy: 'relevance',
      ),
    ));
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more when user is near the bottom
        context.read<CafeBloc>().add(LoadMoreCafes());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _currentSearchQuery = query;
    });

    if (query.isNotEmpty) {
      context.read<CafeBloc>().add(UpdateSearchQuery(query:query));
    } else {
      // If search is cleared, reload with current filters
      _applyCurrentFilters();
    }
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        _searchController.clear();
        _currentSearchQuery = '';
        // Reload cafes without search
        _applyCurrentFilters();
      }
    });
  }

  void _applyCurrentFilters() {
    context.read<CafeBloc>().add(ApplyFilters(
      categoryId: _selectedCategoryId,
      location: _selectedLocation,
      priceRange: _selectedPriceRange,
      minRating: _selectedMinRating,
      sortBy: _selectedSortBy,
    ));
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategoryId = null;
      _selectedLocation = null;
      _selectedPriceRange = null;
      _selectedMinRating = null;
      _selectedSortBy = 'relevance';
    });
    context.read<CafeBloc>().add(ClearFilters());
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _applyCurrentFilters();
  }

  void _onLocationSelected(String location) {
    setState(() {
      _selectedLocation = location;
    });
    _applyCurrentFilters();
  }

  void _toggleFavorite(String cafeId) {
    context.read<CafeBloc>().add(ToggleCafeFavorite(cafeId: cafeId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CafeBloc, CafeState>(
      listener: (context, state) {
        if (state is CafeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CafeFavoriteUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: state.isFavorite ? Colors.green : Colors.orange,
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          GestureDetector(
            onTap: () {
              if (!isSearchActive) {
                _toggleSearch();
              }
            },
            child: CustomTextFormField(
              hint: 'Search Location, Meals and more....',
              label: '',
              enabled: isSearchActive,
              controller: _searchController,
              borderColor: AppColors.textFormFieldBackgroundColor,
              backgroundColor: AppColors.textFormFieldBackgroundColor,
              widget: const Icon(Icons.search),
              onChanged: _handleSearch,
              suffixIcon: isSearchActive
                  ? GestureDetector(
                onTap: _toggleSearch,
                child: const Icon(Icons.cancel_outlined),
              )
                  : null,
            ),
          ),

          // Filter Section (when search is active)
          if (isSearchActive) ...[
            const SizedBox(height: 10),
            BlocBuilder<CafeBloc, CafeState>(
              builder: (context, state) {
                if (state is CafeFilterOptionsLoaded ||
                    context.read<CafeBloc>().filterOptions != null) {
                  final filterOptions = state is CafeFilterOptionsLoaded
                      ? state.filterOptions
                      : context.read<CafeBloc>().filterOptions!;

                  return FilteringItem(
                    filterOptions: filterOptions,
                    selectedCategoryId: _selectedCategoryId,
                    selectedLocation: _selectedLocation,
                    selectedPriceRange: _selectedPriceRange,
                    selectedMinRating: _selectedMinRating,
                    onCategorySelected: _onCategorySelected,
                    onLocationSelected: _onLocationSelected,
                    onPriceRangeSelected: (priceRange) {
                      setState(() {
                        _selectedPriceRange = priceRange;
                      });
                      _applyCurrentFilters();
                    },
                    onRatingSelected: (rating) {
                      setState(() {
                        _selectedMinRating = rating;
                      });
                      _applyCurrentFilters();
                    },
                    onClearFilters: _clearAllFilters,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            _buildFilterOptionsContainer(),
          ],

          // Cafe List Section
          if (!isSearchActive) ...[
            const SizedBox(height: 10),
            TextStyles.textHeadings(textValue: "Around You", textSize: 18),
          ],

          const SizedBox(height: 10),

          // Cafes List
          BlocBuilder<CafeBloc, CafeState>(
            builder: (context, state) {
              if (state is CafeLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is CafeSearchSuccess) {
                if (state.cafes.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildCafesList(state.cafes, state.hasMore);
              } else if (state is CafeLoadingMore) {
                return _buildCafesList(state.currentCafes, true, showLoadingMore: true);
              } else if (state is CafeNearbyLoaded) {
                return _buildCafesList(state.nearbyCafes, false);
              } else if (state is CafeError) {
                return _buildErrorState(state.message);
              }

              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCafesList(List<CafeModel> cafes, bool hasMore, {bool showLoadingMore = false}) {
    return Column(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: cafes.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildCafeItem(cafes[index]);
          },
        ),
        if (showLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (hasMore && !showLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Scroll to load more...',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCafeItem(CafeModel cafe) {
    final isFavorite = context.read<CafeBloc>().isCafeFavorite(cafe.id);

    return GestureDetector(
      onTap: () {
        AppNavigator.pushAndStackPage(
          context,
          page: SingleCafe(cafeId: cafe.id),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Cafe Image
              Container(
                height: 180,
                width: AppUtils.deviceScreenSize(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cafe.primaryImageUrl.isNotEmpty
                          ? Image.network(
                        cafe.primaryImageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.cafeImg,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.asset(
                        AppImages.cafeImg,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Discount Badge (if applicable)
                    Positioned(
                      top: 15,
                      left: 5,
                      child: Container(
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextStyles.textSubHeadings(
                            textValue: '30% off', // You can make this dynamic
                            textColor: AppColors.white,
                            textSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cafe Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Favorite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(alignment: Alignment.topLeft,child:TextStyles.textHeadings(
                              textValue: cafe.name,
                              textSize: 15,
                            )),
                          ),
                          GestureDetector(
                            onTap: () => _toggleFavorite(cafe.id),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : AppColors.textColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.red),
                          Expanded(
                            child: CustomText(
                              text: cafe.displayLocation,
                              size: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Rating and Estimated Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.yellow, size: 15),
                              CustomText(text: cafe.averageRating.toStringAsFixed(1)),
                              const SizedBox(width: 4),
                              CustomText(
                                text: '(${cafe.totalReviews})',
                                size: 12,
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            constraints: BoxConstraints(
                              maxWidth: AppUtils.deviceScreenSize(context).width / 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timer_outlined, color: AppColors.green),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: CustomText(
                                    text: 'Est. order time: ${cafe.estimatedPrepTime} min',
                                    size: 14,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.coffee_outlined,
              size: 64,
              color: AppColors.textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            TextStyles.textHeadings(
              textValue: "No cafes found",
              textSize: 20,
            ),
            const SizedBox(height: 8),
            const CustomText(
              text: "Try adjusting your search or filters",
              size: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearAllFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            TextStyles.textHeadings(
              textValue: "Something went wrong",
              textSize: 20,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: message,
              size: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CafeBloc>().add(SearchCafes(
                  request: CafeSearchRequest(
                    limit: 20,
                    sortBy: 'relevance',
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptionsContainer() {
    return BlocBuilder<CafeBloc, CafeState>(
      builder: (context, state) {
        final filterOptions = context.read<CafeBloc>().filterOptions;

        if (filterOptions == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Filters Display
            if (_hasActiveFilters()) ...[
              const SizedBox(height: 10),
              _buildActiveFiltersChips(),
              const SizedBox(height: 15),
            ],

            // Top Categories
            TextStyles.textHeadings(textValue: "Top Categories", textSize: 20),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: filterOptions.categories.take(7).map((category) {
                  final isSelected = _selectedCategoryId == category.id;
                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        setState(() {
                          _selectedCategoryId = null;
                        });
                      } else {
                        _onCategorySelected(category.id);
                      }
                    },
                    child: _buildFilterOption(
                      category.name,
                      isSelected: isSelected,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),

            // Top Locations
            TextStyles.textHeadings(textValue: "Top Locations", textSize: 20),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: filterOptions.locations.take(5).map((location) {
                  final isSelected = _selectedLocation == location.city;
                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        setState(() {
                          _selectedLocation = null;
                        });
                      } else {
                        _onLocationSelected(location.city);
                      }
                    },
                    child: _buildFilterOption(
                      location.displayName,
                      isSelected: isSelected,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategoryId != null ||
        _selectedLocation != null ||
        _selectedPriceRange != null ||
        _selectedMinRating != null ||
        _currentSearchQuery.isNotEmpty;
  }

  Widget _buildActiveFiltersChips() {
    final chips = <Widget>[];

    if (_currentSearchQuery.isNotEmpty) {
      chips.add(_buildFilterChip('Search: $_currentSearchQuery', () {
        _searchController.clear();
        _handleSearch('');
      }));
    }

    if (_selectedCategoryId != null) {
      final filterOptions = context.read<CafeBloc>().filterOptions;
      final category = filterOptions?.categories.firstWhere(
            (c) => c.id == _selectedCategoryId,
        orElse: () => CategoryModel(id: '', name: 'Unknown', description: '', image: ''),
      );
      chips.add(_buildFilterChip('Category: ${category?.name}', () {
        setState(() {
          _selectedCategoryId = null;
        });
        _applyCurrentFilters();
      }));
    }

    if (_selectedLocation != null) {
      chips.add(_buildFilterChip('Location: $_selectedLocation', () {
        setState(() {
          _selectedLocation = null;
        });
        _applyCurrentFilters();
      }));
    }

    if (_selectedPriceRange != null) {
      chips.add(_buildFilterChip('Price: ${_selectedPriceRange!.label}', () {
        setState(() {
          _selectedPriceRange = null;
        });
        _applyCurrentFilters();
      }));
    }

    if (_selectedMinRating != null) {
      chips.add(_buildFilterChip('Rating: ${_selectedMinRating}+', () {
        setState(() {
          _selectedMinRating = null;
        });
        _applyCurrentFilters();
      }));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...chips,
        if (chips.isNotEmpty)
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.appMainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.appMainColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.appMainColor,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.appMainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, {bool isSelected = false}) {
    return Container(
      color: isSelected ? AppColors.appMainColor.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: title,
                size: 18,
                color: isSelected ? AppColors.appMainColor : null,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColors.appMainColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}