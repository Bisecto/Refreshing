import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';

import '../../../res/app_colors.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightPurple,
                  child: TextStyles.textHeadings(textValue: 'P'),
                ),
                SizedBox(
                  width: 5,
                ),
                TextStyles.textSubHeadings(textValue: 'Hey Precious!'),
                SizedBox(
                  width: 3,
                ),
                SvgPicture.asset(
                  AppIcons.finger,
                  height: 20,
                  width: 20,
                )
              ],
            ),
            SvgPicture.asset(
              AppIcons.notification,
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
