import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class SelectChoice extends StatefulWidget {
  final ValueChanged<String> selecteditem;
  final List<String> items;
  final String? initialSelection; // Optional: specify which item should be selected initially

  const SelectChoice({
    super.key,
    required this.selecteditem,
    required this.items,
    this.initialSelection,
  });

  @override
  State<SelectChoice> createState() => _SelectChoiceState();
}

class _SelectChoiceState extends State<SelectChoice> {
  String selecteditem = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.items.length > 1) {
      if (widget.initialSelection != null &&
          widget.items.contains(widget.initialSelection)) {
        // Use provided initial selection if it exists in items
        selecteditem = widget.initialSelection!;
      } else {
        // Default to second item (first actual option, not the label)
        selecteditem = widget.items[1];
      }

      // Notify parent of initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.selecteditem(selecteditem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.items.length,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  // First item is label, don't allow selection
                  return;
                } else {
                  setState(() {
                    selecteditem = widget.items[index];
                    widget.selecteditem(selecteditem);
                  });
                }
              },
              child: _buildItemContainer(
                item: widget.items[index],
                context: context,
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemContainer({
    required String item,
    required BuildContext context,
    required int index,
  }) {
    final isLabel = index == 0;
    final isSelected = selecteditem == item;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: isLabel
          ? SizedBox(
        height: 50,
        width: AppUtils.deviceScreenSize(context).width / 5.1,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextStyles.textHeadings(
            textValue: item,
            textSize: 18,
          ),
        ),
      )
          : Container(
        height: 50,
        width: AppUtils.deviceScreenSize(context).width / 5.1,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.appMainColor
              : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? null
              : Border.all(
            color: AppColors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: CustomText(
            text: item,
            size: 16,
            weight: FontWeight.w600,
            color: isSelected
                ? AppColors.white
                : AppColors.textColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Alternative: More flexible version for different use cases
class FlexibleSelectChoice extends StatefulWidget {
  final ValueChanged<String> onSelectionChanged;
  final List<String> items;
  final String? label; // Separate label parameter
  final String? initialSelection;
  final bool showLabel;
  final double? itemWidth;
  final Color? selectedColor;
  final Color? unselectedColor;

  const FlexibleSelectChoice({
    super.key,
    required this.onSelectionChanged,
    required this.items,
    this.label,
    this.initialSelection,
    this.showLabel = true,
    this.itemWidth,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  State<FlexibleSelectChoice> createState() => _FlexibleSelectChoiceState();
}

class _FlexibleSelectChoiceState extends State<FlexibleSelectChoice> {
  String selectedItem = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.items.isNotEmpty) {
      if (widget.initialSelection != null &&
          widget.items.contains(widget.initialSelection)) {
        selectedItem = widget.initialSelection!;
      } else {
        selectedItem = widget.items.first;
      }

      // Notify parent of initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectionChanged(selectedItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional label
          if (widget.showLabel && widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextStyles.textHeadings(
                textValue: widget.label!,
                textSize: 18,
              ),
            ),

          // Selection options
          SizedBox(
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.items.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = selectedItem == item;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                      widget.onSelectionChanged(selectedItem);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 50,
                    width: widget.itemWidth ??
                        AppUtils.deviceScreenSize(context).width / 5.1,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (widget.selectedColor ?? AppColors.appMainColor)
                          : (widget.unselectedColor ?? AppColors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? null
                          : Border.all(
                        color: AppColors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        text: item,
                        size: 16,
                        weight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Usage examples for the enhanced versions:

/*
// Original usage (your current way):
SelectChoice(
  selecteditem: (String value) {
    _updateCustomization('Size', value);
  },
  items: ['Size', 'Regular', 'Small', 'Large'],
)

// Enhanced version with initial selection:
SelectChoice(
  selecteditem: (String value) {
    _updateCustomization('Size', value);
  },
  items: ['Size', 'Regular', 'Small', 'Large'],
  initialSelection: 'Regular', // This will be pre-selected
)

// Flexible version (separate label):
FlexibleSelectChoice(
  label: 'Size',
  onSelectionChanged: (String value) {
    _updateCustomization('Size', value);
  },
  items: ['Regular', 'Small', 'Large'],
  initialSelection: 'Regular',
)

// Flexible version (no label):
FlexibleSelectChoice(
  showLabel: false,
  onSelectionChanged: (String value) {
    _updateCustomization('Size', value);
  },
  items: ['Regular', 'Small', 'Large'],
  selectedColor: Colors.blue,
  itemWidth: 80,
)
*/