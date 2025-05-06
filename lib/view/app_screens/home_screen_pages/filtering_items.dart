import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class FilteringItem extends StatefulWidget {
  final ValueChanged<String> selectedTerm;

  const FilteringItem({
    super.key,
    required this.selectedTerm,
  });

  @override
  State<FilteringItem> createState() => _FilteringItemState();
}

class _FilteringItemState extends State<FilteringItem> {
  final List<String> terms = ['All', 'Menu', 'Discounts', 'Location'];

  String selectedTerm = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: terms.length,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTerm = terms[index];
                  widget.selectedTerm(selectedTerm);
                });
               // _scrollToIndex(index);
              },
              child: termContainer(term: terms[index], context: context),
            );
          },
        ),
      ),
    );
  }

  // void _scrollToIndex(int index) {
  //   double offset = (index * (AppUtils.deviceScreenSize(context).width / 3)) -
  //       (AppUtils.deviceScreenSize(context).width / 2) +
  //       (AppUtils.deviceScreenSize(context).width / 6);
  //   _scrollController.animateTo(
  //     offset,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  Widget termContainer({required String term, required context}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 50,
        width: AppUtils.deviceScreenSize(context).width / 5.1,
        decoration: BoxDecoration(
          color:
              selectedTerm == term ? AppColors.appMainColor : AppColors.grey,
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.15),
            //   spreadRadius: 0,
            //   blurRadius: 10,
            //   offset: const Offset(0, 4),
            // ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CustomText(
            text: term,
            size: 16,
            weight: FontWeight.w600,
            color: selectedTerm == term ? AppColors.white : AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
