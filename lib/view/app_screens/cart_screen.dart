import 'package:flutter/material.dart';
import 'package:refreshing_co/view/app_screens/cart_app_bar/cart_app_bar.dart';

import '../../res/app_colors.dart';
import '../widgets/app_custom_text.dart';
import 'cart_app_bar/cart_tab_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                    child: TextStyles.textHeadings(textValue: 'Cart',textSize: 20),
                  ),
                  CartTabController()
                ],
              ),
            ),
          )),
    );
  }
}
