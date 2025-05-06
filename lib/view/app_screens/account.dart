import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/utills/app_utils.dart';

import '../../res/app_colors.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_button.dart';

// Assuming you have your custom widgets and AppColors predefined
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet balance and subscription section
            _buildWalletAndSubscriptionSection(),

            const SizedBox(height: 20), // Add some spacing between sections

            // Order history section
            Expanded(child: _buildOrderHistory()),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletAndSubscriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wallet balance
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightPurple,
                  child: TextStyles.textHeadings(textValue: 'P'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Wallet Balance',
                      size: 14,
                      color: AppColors.textColor,
                    ),
                    TextStyles.textHeadings(
                      textValue: '£ 30.50',
                      textSize: 16,
                      textColor: Colors.black,
                    ),
                  ],
                ),
                const Spacer(),
                SvgPicture.asset(AppIcons.notification)
              ],
            ),
          ),
        ),

        Center(
          child: FormButton(
            onPressed: () {},
            bgColor: AppColors.appMainColor,
            text: "Fund wallet",
            borderRadius: 8,
          ),
        ),

        const SizedBox(height: 20), // Space between button and subscription

        // Active subscription details
        TextStyles.textHeadings(
          textValue: 'Active Subscription',
          textSize: 16,
          textColor: Colors.black,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.circle, color: AppColors.lightPurple, size: 20),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextStyles.textHeadings(
                  textValue: 'Basic',
                  textSize: 16,
                  textColor: AppColors.black,
                ),
                CustomText(
                  text: '£2.10 Elite / Month',
                  size: 14,
                  color: AppColors.textColor,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order history heading
        TextStyles.textHeadings(
          textValue: 'Order History',
          textSize: 16,
          textColor: Colors.black,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: 5, // Number of orders
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.shade300), // Border color and width
                  ),
                  padding: EdgeInsets.all(16), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb, color: Colors.black),
                              SizedBox(width: 10),
                              TextStyles.textHeadings(
                                textValue: 'Order 235',
                                textSize: 16,
                              )
                            ],
                          ),
                          TextStyles.textHeadings(
                            textValue: '£2.23',
                            textSize: 16,
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green),
                          SizedBox(width: 10),
                          SizedBox(
                            width:
                                AppUtils.deviceScreenSize(context).width - 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: '73 Springfield Dbz',
                                  size: 14,
                                  color: AppColors.textColor,
                                ),
                                CustomText(
                                  text: '27/09/2024 9:45 AM',
                                  size: 12,
                                  color: AppColors.textColor.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
