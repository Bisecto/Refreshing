import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refreshing_co/res/app_icons.dart';
import 'package:refreshing_co/res/app_images.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/reward_pages/subscribe_page.dart';
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
              SubscriptionCouponPage()
            ],
          ),
        ),
      )),
    );
  }
}

class SubscriptionCouponPage extends StatefulWidget {
  @override
  State<SubscriptionCouponPage> createState() => _SubscriptionCouponPageState();
}

class _SubscriptionCouponPageState extends State<SubscriptionCouponPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subscription Section
          TextStyles.textHeadings(textValue: 'Subscriptions', textSize: 20),

          const SizedBox(height: 16),
          SubscriptionOption(
            'Basic',
            '£2.10 / Month',
            true,
          ),
          SubscriptionOption(
            'Elite',
            '£3.10 / Month',
            false,
          ),
          const SizedBox(height: 0),
          FormButton(
            onPressed: () {
              AppNavigator.pushAndStackPage(context, page: SubscriptionPage());
            },
            disableButton: selectedSub==null,
            text: 'Subscribe',
            bgColor: AppColors.appMainColor,
            borderRadius: 8,
          ),
          const SizedBox(height: 0),

          // Search Section
          CustomTextFormField(
            controller: searchController,
            hint: 'Search available coupons...',
            label: '',
            backgroundColor: AppColors.grey,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                AppIcons.tag,
                height: 10,
                width: 10,
              ),
            ),
            widget: const Icon(Icons.search),
          ),

          const SizedBox(height: 24),
          TextStyles.textHeadings(textValue: 'Coupons', textSize: 20),

          const SizedBox(height: 16),
          // Hot Coupon
          CouponCard(
            imageUrl: AppImages.coupon,
            title: 'Signup bonus',
            description:
                'We are giving out a free coupon for your drink worth up to £5. You are our MVP! 🎉',
            buttonText: 'Use',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          // Other Coupons
          CouponCard(
            imageUrl: AppImages.coupon,
            title: 'WELCOME 10',
            description: '10% off your first order',
            buttonText: 'Use',
            onPressed: () {},
            hasTimer: true,
            timerDuration: const Duration(hours: 21, minutes: 10, seconds: 45),
          ),
        ],
      ),
    );
  }

  String? selectedSub;

  Widget SubscriptionOption(
    final String title,
    final String price,
    final bool isPopular,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey),
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: CustomText(
                  text: title,
                  size: 16,
                  color: AppColors.black,
                ),
                subtitle: CustomText(
                  text: price,
                  size: 16,
                  color: AppColors.textColor,
                ),
                leading: Radio<String>(
                  value: title,
                  // groupValue: selectedSub,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSub = null;
                      selectedSub = value;
                    });
                    print("Selected subscription: $value");
                  },
                  groupValue: selectedSub,
                ),
              ),
            ),
            if (isPopular)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const CustomText(
                    text: 'Popular',
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final bool hasTimer;
  final Duration? timerDuration;

  CouponCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.hasTimer = false,
    this.timerDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageUrl,
                height: 130, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            CustomText(
              text: title,
              size: 20,
              color: AppColors.black,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: description,
              size: 16,
              color: AppColors.textColor,
              maxLines: 5,
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasTimer)
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      CustomText(
                        text:
                            '${timerDuration?.inHours ?? 0}:${(timerDuration?.inMinutes.remainder(60) ?? 0).toString().padLeft(2, '0')}:${(timerDuration?.inSeconds.remainder(60) ?? 0).toString().padLeft(2, '0')}',
                        size: 16,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
              ],
            ),
            FormButton(
              onPressed: onPressed,
              text: buttonText,
              bgColor: AppColors.appMainColor,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
