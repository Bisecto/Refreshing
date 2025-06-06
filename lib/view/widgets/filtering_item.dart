// lib/view/app_screens/cafe_list/filtering_items.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../res/app_colors.dart';
import '../../model/cafe/adons.dart';
import 'app_custom_text.dart';

class FilteringItem extends StatefulWidget {
  final FilterOptionsModel filterOptions;
  final String? selectedCategoryId;
  final String? selectedLocation;
  final PriceRangeModel? selectedPriceRange;
  final double? selectedMinRating;
  final Function(String) onCategorySelected;
  final Function(String) onLocationSelected;
  final Function(PriceRangeModel) onPriceRangeSelected;
  final Function(double) onRatingSelected;
  final VoidCallback onClearFilters;

  const FilteringItem({
    Key? key,
    required this.filterOptions,
    this.selectedCategoryId,
    this.selectedLocation,
    this.selectedPriceRange,
    this.selectedMinRating,
    required this.onCategorySelected,
    required this.onLocationSelected,
    required this.onPriceRangeSelected,
    required this.onRatingSelected,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  State<FilteringItem> createState() => _FilteringItemState();
}

class _FilteringItemState extends State<FilteringItem> {
  bool _showPriceFilter = false;
  bool _showRatingFilter = false;
  bool _showSortFilter = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Buttons Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton(
                  'Price',
                  _showPriceFilter,
                  widget.selectedPriceRange != null,
                      () {
                    setState(() {
                      _showPriceFilter = !_showPriceFilter;
                      _showRatingFilter = false;
                      _showSortFilter = false;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _buildFilterButton(
                  'Rating',
                  _showRatingFilter,
                  widget.selectedMinRating != null,
                      () {
                    setState(() {
                      _showRatingFilter = !_showRatingFilter;
                      _showPriceFilter = false;
                      _showSortFilter = false;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _buildFilterButton(
                  'Sort',
                  _showSortFilter,
                  false,
                      () {
                    setState(() {
                      _showSortFilter = !_showSortFilter;
                      _showPriceFilter = false;
                      _showRatingFilter = false;
                    });
                  },
                ),
                const SizedBox(width: 12),
                if (_hasActiveFilters())
                  _buildClearButton(),
              ],
            ),
          ),

          // Filter Options
          if (_showPriceFilter) ...[
            const SizedBox(height: 16),
            _buildPriceFilterOptions(),
          ],
          if (_showRatingFilter) ...[
            const SizedBox(height: 16),
            _buildRatingFilterOptions(),
          ],
          if (_showSortFilter) ...[
            const SizedBox(height: 16),
            _buildSortFilterOptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      String title,
      bool isExpanded,
      bool hasSelection,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isExpanded || hasSelection
              ? AppColors.appMainColor.withOpacity(0.1)
              : AppColors.textFormFieldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded || hasSelection
                ? AppColors.appMainColor
                : AppColors.textFormFieldBackgroundColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isExpanded || hasSelection
                    ? AppColors.appMainColor
                    : AppColors.textColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16,
              color: isExpanded || hasSelection
                  ? AppColors.appMainColor
                  : AppColors.textColor,
            ),
            if (hasSelection) ...[
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.appMainColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: widget.onClearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear,
              size: 16,
              color: Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.filterOptions.priceRanges.map((priceRange) {
            final isSelected = widget.selectedPriceRange?.label == priceRange.label;
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  // Deselect if already selected
                  return;
                } else {
                  widget.onPriceRangeSelected(priceRange);
                }
                setState(() {
                  _showPriceFilter = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.appMainColor
                      : AppColors.textFormFieldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  priceRange.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? AppColors.white : AppColors.textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.filterOptions.ratingRanges.map((ratingRange) {
            final isSelected = widget.selectedMinRating == ratingRange.min;
            return GestureDetector(
              onTap: () {
                widget.onRatingSelected(ratingRange.min);
                setState(() {
                  _showRatingFilter = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.appMainColor
                      : AppColors.textFormFieldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: isSelected ? AppColors.white : AppColors.yellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ratingRange.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? AppColors.white : AppColors.textColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: widget.filterOptions.sortOptions.map((sortOption) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _getSortIcon(sortOption.value),
                size: 20,
                color: AppColors.appMainColor,
              ),
              title: Text(
                sortOption.label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              onTap: () {
                // Handle sort selection - you can add this functionality
                setState(() {
                  _showSortFilter = false;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getSortIcon(String sortValue) {
    switch (sortValue) {
      case 'rating':
        return Icons.star;
      case 'price_low':
        return Icons.arrow_upward;
      case 'price_high':
        return Icons.arrow_downward;
      case 'distance':
        return Icons.location_on;
      case 'newest':
        return Icons.new_releases;
      default:
        return Icons.sort;
    }
  }

  bool _hasActiveFilters() {
    return widget.selectedCategoryId != null ||
        widget.selectedLocation != null ||
        widget.selectedPriceRange != null ||
        widget.selectedMinRating != null;
  }
}






// lib/view/app_screens/single_cafe/single_cafe.dart - Updated


class SingleCafe extends StatelessWidget {
  final String? cafeId;

  const SingleCafe({Key? key, this.cafeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cafe Details',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CustomText(
                  text: 'Cafe details will be implemented here',
                  size: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              if (cafeId != null)
                CustomText(
                  text: 'Cafe ID: $cafeId',
                  size: 14,
                ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'This page will show:',
                size: 16,
                color: AppColors.black,
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: '• Cafe images and gallery',
                size: 14,
              ),
              const SizedBox(height: 5),
              const CustomText(
                text: '• Menu items and pricing',
                size: 14,
              ),
              const SizedBox(height: 5),
              const CustomText(
                text: '• Reviews and ratings',
                size: 14,
              ),
              const SizedBox(height: 5),
              const CustomText(
                text: '• Location and contact info',
                size: 14,
              ),
              const SizedBox(height: 5),
              const CustomText(
                text: '• Opening hours',
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



