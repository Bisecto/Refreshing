import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_utils.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../widgets/app_custom_text.dart';

class CartAppBar extends StatefulWidget {
  const CartAppBar({super.key});

  @override
  State<CartAppBar> createState() => _CartAppBarState();
}

class _CartAppBarState extends State<CartAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextStyles.textHeadings(textValue: 'My Cart',textSize: 20),  CircleAvatar(
            //   backgroundColor: AppColors.lightPurple,
            //   child: TextStyles.textHeadings(textValue: 'P'),
            // ),
            Image.asset( AppImages.refresh,height: 70,width: AppUtils.deviceScreenSize(context).width/3,),
            // SvgPicture.asset(
            //   AppIcons.notification,
            //   height: 20,
            //   width: 20,
            // ),
          ],
        ),
      ),
    );
  }
}
