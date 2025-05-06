import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_input.dart';

import '../../res/app_colors.dart';
import 'home_screen_pages/app_bar.dart';
import 'home_screen_pages/cafe_list.dart';
import 'home_screen_pages/filtering_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                // Container(
                //   height: 300,
                //   width: AppUtils.deviceScreenSize(context).width,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage(AppImages.homeBackground),
                //       fit: BoxFit.fill,
                //     ),
                //     //shape: BoxShape.circle,
                //   ),
                //   child: Container(
                //     height: 300,
                //     width: AppUtils.deviceScreenSize(context).width,
                //     color: AppColors.black.withOpacity(0.4),
                //     child: Padding(
                //       padding: const EdgeInsets.all(20.0),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             children: [
                //               //const SizedBox(height: 20,),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   const Icon(
                //                     Icons.location_on_outlined,
                //                     color: AppColors.white,
                //                   ),
                //                   const SizedBox(
                //                     width: 0,
                //                   ),
                //                   TextStyles.textSubHeadings(
                //                       textValue: 'Current Location',
                //                       textColor: AppColors.white,
                //                       textSize: 20)
                //                 ],
                //               )
                //             ],
                //           ),
                //           Column(
                //             children: [
                //               const Align(
                //                 alignment: Alignment.topLeft,
                //                 child: CustomText(
                //                   text: 'Suggested keywords',
                //                   color: AppColors.white,
                //                   size: 14,
                //                 ),
                //               ),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Container(
                //                     height: 50,
                //                     width:
                //                         AppUtils.deviceScreenSize(context).width /
                //                             2.3,
                //                     decoration: BoxDecoration(
                //                       color: AppColors.black.withOpacity(0.3),
                //                     ),
                //                     child: const Padding(
                //                       padding: EdgeInsets.all(4.0),
                //                       child: Center(
                //                         child: CustomText(
                //                           text:
                //                               'A nice Cozy place where i can walk in an take coffee',
                //                           color: AppColors.white,
                //                           size: 13,
                //                           maxLines: 2,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   Container(
                //                     height: 50,
                //                     width:
                //                         AppUtils.deviceScreenSize(context).width /
                //                             2.3,
                //                     decoration: BoxDecoration(
                //                       color: AppColors.black.withOpacity(0.3),
                //                     ),
                //                     child: const Padding(
                //                       padding: EdgeInsets.all(4.0),
                //                       child: Center(
                //                         child: CustomText(
                //                           text:
                //                               'An outdoor place with late and hot cappuccino...',
                //                           color: AppColors.white,
                //                           size: 13,
                //                           maxLines: 2,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               CustomTextFormField(
                //                 controller: searchController,
                //                 hint:
                //                     'Search by location,keyword,available cups etc...',
                //                 label: '',
                //               )
                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Image.asset(AppImages.refresh, height: 70, width: 150),
                const CustomAppBar(),


                // FilteringItem(
                //   selectedTerm: (String value) {},
                // ),
                Padding(padding: const EdgeInsets.only(top: 1.0), child: CafeList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
