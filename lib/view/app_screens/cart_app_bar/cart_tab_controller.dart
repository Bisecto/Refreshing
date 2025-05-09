import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:refreshing_co/view/app_screens/cart_app_bar/tab_controller_pages/available_order.dart';
import 'package:refreshing_co/view/app_screens/cart_app_bar/tab_controller_pages/running_orders.dart';

import '../../../../res/app_icons.dart';
import '../../../../utills/custom_theme.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class CartTabController extends StatefulWidget {
  final Function(int) onPageChanged;

  const CartTabController({super.key, required this.onPageChanged});

  @override
  State<CartTabController> createState() => _CartTabControllerState();
}

class _CartTabControllerState extends State<CartTabController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          height: AppUtils.deviceScreenSize(context).height,
          width: AppUtils.deviceScreenSize(context).width,
          color: AppColors.white,
          child: cardTabController(),
        ),
      ),
    );
  }

  Widget cardTabController() {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  //text: 'Available in cart',

                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.goft,height: 20,width: 20,color: Colors.grey,),
                      TextStyles.textHeadings(textValue:  " Available in cart",textSize: 14)
                    ],
                  ),
                ),
                 Tab(
                   // text: 'Running Orders',
                   // icon: Icon(Icons.my_library_books_rounded,size: 20,),
                  child: Row(
                    children: [
                      Icon(Icons.my_library_books_rounded,size: 20,),
                      TextStyles.textHeadings(textValue: "Running Orders",textSize: 14)
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: AppUtils.deviceScreenSize(context).height-70, // Set an appropriate height
            width: AppUtils.deviceScreenSize(context).width,
            child:  TabBarView(
              children: [AvailableOrder(onPageChanged:widget.onPageChanged,), RunningOrders()],
            ),
          ),
        ],
      ),
    );
  }
}
