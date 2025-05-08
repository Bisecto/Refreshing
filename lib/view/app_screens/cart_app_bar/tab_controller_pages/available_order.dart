import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_input.dart';

class AvailableOrder extends StatefulWidget {
  const AvailableOrder({super.key});

  @override
  State<AvailableOrder> createState() => _AvailableOrderState();
}

class _AvailableOrderState extends State<AvailableOrder> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          availableOrderContainer("Order #230"),
          FormButton(
            onPressed: () {},
            text: "Explore menu",
            bgColor: AppColors.grey,
            textColor: AppColors.black,
            weight: FontWeight.bold,
            borderRadius: 10,
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: TextStyles.textHeadings(
          //       textValue: 'You have 5 orders in your cart', textSize: 18),
          // ),
          // CustomTextFormField(
          //   controller: searchController,
          //   hint: 'Search cart...',
          //   label: '',
          //   backgroundColor: AppColors.grey,
          //   widget: const Icon(Icons.search),
          // // ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
          //   child: SizedBox(
          //     height: 3 * 130,
          //     child: ListView.builder(
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemCount: 3,
          //       padding: EdgeInsets.zero,
          //       itemBuilder: (BuildContext context, int index) {
          //         return availabOrderContainer(
          //             'Hezelnut Cappuccino', 'Central Station', index);
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: TextStyles.textHeadings(
          //       textValue: 'Order Summary', textSize: 18),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const CustomText(
          //       text: "Subtotal",
          //       color: AppColors.textColor,
          //       size: 15,
          //     ),
          //     TextStyles.richTexts(
          //         text1: '£',
          //         size: 15,
          //         color: AppColors.black,
          //         text2: ' 2.00',
          //         color2: AppColors.textColor)
          //     //CustomText(text: "Subtotal",color: AppColors.textColor,)
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const CustomText(
          //       text: "Tax",
          //       color: AppColors.textColor,
          //       size: 15,
          //     ),
          //     TextStyles.richTexts(
          //         text1: '£',
          //         size: 15,
          //         color: AppColors.black,
          //         text2: ' 0.23',
          //         color2: AppColors.textColor)
          //     //CustomText(text: "Subtotal",color: AppColors.textColor,)
          //   ],
          // ),
          // const Divider(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextStyles.textHeadings(textValue: 'Total'),
          //     TextStyles.richTexts(
          //         text1: '£',
          //         size: 15,
          //         color: AppColors.black,
          //         text2: ' 2.23',
          //         color2: AppColors.textColor)
          //     //CustomText(text: "Subtotal",color: AppColors.textColor,)
          //   ],
          // ),
          // FormButton(
          //   onPressed: () {},
          //   text: "Order Now",
          //   bgColor: AppColors.appMainColor,
          //   borderRadius: 8,
          // )
        ],
      ),
    );
  }

  Widget availableOrderContainer(String orderNo) {
    return Container(
      height: 140,
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
                      child: SvgPicture.asset(
                        AppIcons.goft,
                        color: AppColors.white,
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
                Icon(Icons.remove_circle, color: AppColors.black),
              ],
            ),
            FormButton(
              onPressed: () {},
              text: "View details",
              bgColor: AppColors.appMainColor,
              height: 45,
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  // List<bool> isSelected =
  //     List.generate(6, (index) => false); // To track checkbox selections
  // List<int> quantities =
  //     List.generate(6, (index) => 0); // To track quantities of each item
  //
  // Widget availabOrderContainer(String name, String desc, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
  //     child: Container(
  //       height: 115,
  //       decoration: BoxDecoration(
  //           color: AppColors.grey.withOpacity(0.5),
  //           borderRadius: BorderRadius.circular(15)),
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(5.0,10,5,10),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           //mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             // Checkbox for selecting multiple items
  //             Checkbox(
  //               value: isSelected[index],
  //               onChanged: (bool? newValue) {
  //                 setState(() {
  //                   isSelected[index] = newValue ?? false;
  //                   if (!isSelected[index]) {
  //                     // If unchecked, reset quantity to 0
  //                     quantities[index] = 0;
  //                   }
  //                 });
  //               },
  //             ),
  //             Container(
  //               height: 90,
  //               width: 90,
  //               decoration: BoxDecoration(
  //                   color: AppColors.grey.withOpacity(0.5),
  //                   borderRadius: BorderRadius.circular(15),
  //                   image: const DecorationImage(
  //                       image: NetworkImage(
  //                         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYOdDjHm0xP85-IG91igaKUL3w4T7zClpGNA&s',
  //                       ),
  //                       fit: BoxFit.fill)),
  //             ),
  //             const SizedBox(
  //               width: 5,
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextStyles.textHeadings(textValue: name,textSize: 14),
  //                 SizedBox(
  //                   width: AppUtils.deviceScreenSize(context).width / 2.5,
  //                   child: TextStyles.textDetails(
  //                       textValue: desc,
  //                       textColor: AppColors.textColor,
  //                       textSize: 12),
  //                 ),
  //                 const SizedBox(
  //                   width: 0,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 10.0),
  //                   child: Container(
  //                     width: AppUtils.deviceScreenSize(context).width / 2,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         TextStyles.textHeadings(textValue: '£2',textSize: 14),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: <Widget>[
  //                             // Minus button
  //                             GestureDetector(
  //                               onTap:
  //                                   isSelected[index] && quantities[index] > 0
  //                                       ? () {
  //                                           setState(() {
  //                                             quantities[index]--;
  //                                           });
  //                                         }
  //                                       : null,
  //                               // Disable button if not selected or quantity is 0
  //                               child: Container(
  //                                 height: 20,
  //                                 width: 20,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.black,
  //                                   shape: BoxShape.circle,
  //                                 ),
  //                                 child: const Icon(
  //                                   Icons.remove,
  //                                   color: AppColors.white,
  //                                   size: 14, // Adjusted size for better fit
  //                                 ),
  //                               ),
  //                             ),
  //
  //                             // Display counter (quantity)
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                   horizontal: 20.0),
  //                               child: TextStyles.textHeadings(
  //                                   textValue: '${quantities[index]}',
  //                                   textSize: 12,
  //                                   textColor: AppColors.black),
  //                             ),
  //
  //                             // Add button
  //                             GestureDetector(
  //                               onTap: isSelected[index]
  //                                   ? () {
  //                                       setState(() {
  //                                         quantities[index]++;
  //                                       });
  //                                     }
  //                                   : null, // Disable if not selected
  //                               child: Container(
  //                                 height: 20,
  //                                 width: 20,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.black,
  //                                   shape: BoxShape.circle,
  //                                 ),
  //                                 child: const Icon(
  //                                   Icons.add,
  //                                   color: AppColors.white,
  //                                   size: 14, // Adjusted size for better fit
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
