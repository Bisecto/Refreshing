import 'package:flutter/material.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_utils.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../../res/app_colors.dart';
import '../../widgets/app_custom_text.dart';
import '../cart_app_bar/cart_app_bar.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String? selectedPlan; // Store selected plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,0,20,0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for the subscription type
              const CartAppBar(),

              AppBar(
                title: const Text('Subscription'),
                backgroundColor: AppColors.white,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextStyles.textHeadings(
                  textValue: 'Basic',
                  textSize: 20,
                ),
              ),
              // CustomText(
              //   text: 'Basic',
              //   size: 20,
              //   color: Colors.black,
              //   weight: FontWeight.bold,
              // ),
              const SizedBox(height: 10),

              // Subscription image and description
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImages.subscribeImg,
                      width: AppUtils.deviceScreenSize(context).width,
                    ),
                    // Replace with your image
                    const SizedBox(height: 10),
                    TextStyles.textHeadings(
                      textValue: 'Subscribe to Refreshing & Co basic plan',
                      textSize: 16,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      text:
                          'We are giving out a free coupon for your drink and lots of exciting benefits like',
                      size: 14,
                      maxLines: 3,
                      color: AppColors.textColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Radio buttons for selecting between "Yearly" and "Monthly"
              _buildPlanOptions(),

              const SizedBox(height: 20),

              // Benefits section
             Align(
               alignment: Alignment.topLeft,
               child:  TextStyles.textHeadings(
                 textValue: 'Benefits',
                 textSize: 18,
                 textColor: Colors.black,
               ),
             ),
              const SizedBox(height: 10),
              _buildBenefitItem(
                  'Swift Deliver', 'Have your order delivered swiftly'),
              _buildBenefitItem('Premium Discounts',
                  'Get premium discounts on all purchases and orders'),
              _buildBenefitItem('Premium Discounts',
                  'Get premium discounts on all purchases and orders'),
              _buildBenefitItem('Premium Discounts',
                  'Get premium discounts on all purchases and orders'),

              const Spacer(),
              const SizedBox(height: 10),

              // Subscribe button
              _buildSubscribeButton(),
              const SizedBox(height: 20),

              // Subscription renewal info
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Plans renew automatically, you can cancel anytime',
                  size: 12,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }

  // Widget for the plan options with radio buttons
  Widget _buildPlanOptions() {
    return Column(
      children: [
        ListTile(
          leading: Radio<String>(
            value: 'Yearly',
            groupValue: selectedPlan,
            onChanged: (String? value) {
              setState(() {
                selectedPlan = value;
              });
            },
          ),
          title: CustomText(
            text: '£ 22.40',
            size: 16,
            color: Colors.black,
          ),
          subtitle: CustomText(
            text: 'Save 30%',
            size: 14,
            color: Colors.purple,
          ),
        ),
        ListTile(
          leading: Radio<String>(
            value: 'Monthly',
            groupValue: selectedPlan,
            onChanged: (String? value) {
              setState(() {
                selectedPlan = value;
              });
            },
          ),
          title: CustomText(
            text: '£ 2.10',
            size: 16,
            color: Colors.black,
          ),
          subtitle: CustomText(
            text: 'Monthly',
            size: 14,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  // Widget for displaying benefit items
  Widget _buildBenefitItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,10,0,10),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.lightBlue),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextStyles.textHeadings(textValue: title,textSize: 16),
              // CustomText(
              //   text: title,
              //   size: 16,
              //   color: Colors.black,
              // ),
              CustomText(
                text: subtitle,
                size: 14,
                color: AppColors.textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for the subscribe button
  Widget _buildSubscribeButton() {
    return FormButton(onPressed: (){},bgColor: AppColors.appMainColor,text: "Subscribe",);

    //   ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     padding: const EdgeInsets.symmetric(vertical: 16),
    //     backgroundColor: AppColors.appMainColor,
    //     // Background color
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //   ),
    //   onPressed: () {
    //     // Handle subscription
    //     if (selectedPlan != null) {
    //       print('Subscribed to $selectedPlan plan');
    //     } else {
    //       print('Please select a plan');
    //     }
    //   },
    //   child: Center(
    //     child: CustomText(
    //       text: 'Subscribe',
    //       size: 16,
    //       color: Colors.white,
    //     ),
    //   ),
    // );
  }
}
