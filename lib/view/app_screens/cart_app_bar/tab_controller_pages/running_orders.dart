import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../../res/app_icons.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_input.dart';

class RunningOrders extends StatefulWidget {
  const RunningOrders({super.key});

  @override
  State<RunningOrders> createState() => _RunningOrdersState();
}

class _RunningOrdersState extends State<RunningOrders> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: TextStyles.textHeadings(
          //       textValue: 'Order History', textSize: 18),
          // ),
          // CustomTextFormField(
          //   controller: searchController,
          //   hint: 'Search cart...',
          //   label: '',
          //   backgroundColor: AppColors.grey,
          //   widget: const Icon(Icons.search),
          // ),
          //
          // const SizedBox(
          //   height: 20,
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: TextStyles.textHeadings(
          //       textValue: 'Active Orders', textSize: 18),
          // ),

          runningOrderContainer("Order #230"),
          runningOrderContainer("Order #230"),
          runningOrderContainer("Order #230"),
          runningOrderContainer("Order #230"),
        ],
      ),
    );
  }
  Widget runningOrderContainer(String orderNo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          border: Border.all(width: 1.5, color: AppColors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [

                      CircleAvatar(
                        backgroundColor: AppColors.appMainColor,
                        child: Image.asset(
                          AppImages.coffe,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextStyles.textHeadings(
                            textValue: orderNo,
                            textSize: 16,
                          ),
                          CustomText(text: "1 items £2.30"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(AppIcons.bell),
                      TextStyles.textHeadings(
                        textValue: "Ready",
                        textSize: 14,
                        textColor: AppColors.green
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
