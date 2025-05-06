import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class SelectChoice extends StatefulWidget {
  final ValueChanged<String> selecteditem;
  final List<String> items;

  const SelectChoice(
      {super.key, required this.selecteditem, required this.items});

  @override
  State<SelectChoice> createState() => _SelectChoiceState();
}

class _SelectChoiceState extends State<SelectChoice> {
  // final List<String> items = ['All', 'Menu', 'Discounts', 'Location'];

  String selecteditem = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    selecteditem = widget.items[0];
    super.initState();
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
                } else {
                  setState(() {
                    selecteditem = widget.items[index];
                    widget.selecteditem(selecteditem);
                  });
                }
              },
              child: itemContainer(
                  item: widget.items[index], context: context, index: index),
            );
          },
        ),
      ),
    );
  }

  Widget itemContainer(
      {required String item, required context, required index}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: index == 0
          ? SizedBox(
              height: 50,
              width: AppUtils.deviceScreenSize(context).width / 5.1,
              child: TextStyles.textHeadings(textValue: item, textSize: 18),
            )
          : Container(
              height: 50,
              width: AppUtils.deviceScreenSize(context).width / 5.1,
              decoration: BoxDecoration(
                color: selecteditem == item
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
              ),
              child: Center(
                child: CustomText(
                  text: item,
                  size: 16,
                  weight: FontWeight.w600,
                  color: selecteditem == item
                      ? AppColors.white
                      : AppColors.textColor,
                ),
              ),
            ),
    );
  }
}
