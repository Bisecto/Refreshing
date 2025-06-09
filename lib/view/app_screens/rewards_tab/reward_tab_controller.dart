import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:refreshing_co/view/app_screens/cart_app_bar/tab_controller_pages/available_order.dart';
import 'package:refreshing_co/view/app_screens/cart_app_bar/tab_controller_pages/running_orders.dart';
import 'package:refreshing_co/view/app_screens/rewards_tab/subscription_coupon_page.dart';

import '../../../../res/app_icons.dart';
import '../../../../utills/custom_theme.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class RewardTabController extends StatefulWidget {
  final Function(int) onPageChanged;

  const RewardTabController({super.key, required this.onPageChanged});

  @override
  State<RewardTabController> createState() => _RewardTabControllerState();
}

class _RewardTabControllerState extends State<RewardTabController> {
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
                  child: TextStyles.textHeadings(
                    textValue: "My Rewards",
                    textSize: 14,
                  ),
                ),
                Tab(
                  // text: 'Running Orders',
                  // icon: Icon(Icons.my_library_books_rounded,size: 20,),
                  child: TextStyles.textHeadings(
                    textValue: "Subscription",
                    textSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height:
                AppUtils.deviceScreenSize(context).height -
                70, // Set an appropriate height
            width: AppUtils.deviceScreenSize(context).width,
            child: TabBarView(
              children: [
                RunningOrders(),
                SubscriptionCouponPage(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
