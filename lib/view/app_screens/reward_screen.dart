import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/rewards_tab/reward_tab_controller.dart';
import 'package:refreshing_co/view/app_screens/rewards_tab/subscribe_page.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';
import 'package:refreshing_co/view/widgets/form_input.dart';

import '../../res/app_colors.dart';
import '../widgets/app_custom_text.dart';
import 'cart_app_bar/cart_app_bar.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const CartAppBar(),
              Align(
                alignment: Alignment.center,
                child: TextStyles.textHeadings(
                    textValue: 'My rewards', textSize: 20),
              ),
              RewardTabController(onPageChanged: (int ) {  },)
            ],
          ),
        ),
      )),
    );
  }
}


