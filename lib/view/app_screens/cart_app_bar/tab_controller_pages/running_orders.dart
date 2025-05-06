import 'package:flutter/material.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

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
          Align(
            alignment: Alignment.topLeft,
            child: TextStyles.textHeadings(
                textValue: 'Order History', textSize: 18),
          ),
          CustomTextFormField(
            controller: searchController,
            hint: 'Search cart...',
            label: '',
            backgroundColor: AppColors.grey,
            widget: const Icon(Icons.search),
          ),

          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: TextStyles.textHeadings(
                textValue: 'Active Orders', textSize: 18),
          ),
        ],
      ),
    );
  }
  Widget orderContainer(String name, String desc, int index) {
    return Container(

    );
  }
}
