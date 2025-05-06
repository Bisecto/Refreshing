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
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined,size: 25,),
                SizedBox(
                  width: 5,
                ),
                TextStyles.textHeadings(textValue: 'Ireland'),

              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.notification,
                  height: 25,
                  width: 25,
                ),SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  AppIcons.bag,
                  height: 25,
                  width: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
