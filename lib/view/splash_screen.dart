import 'package:flutter/material.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';

import '../res/app_colors.dart';
import '../res/app_images.dart';
import '../utills/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUtils appUtils = AppUtils();

  @override
  void initState() {
    appUtils.openApp(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appMainColor,
        body: Center(
          child: Container(
            // height: AppUtils.deviceScreenSize(context).height,
            // width: AppUtils.deviceScreenSize(context).width,
            decoration: const BoxDecoration(
              color: AppColors.appMainColor,

              // image: DecorationImage(image: AssetImage(AppImages.splashLogo,),fit: BoxFit.fill)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextStyles.textHeadings(
                    textValue: "Refreshing\n.co",
                    textSize: 20,
                    textColor: AppColors.white)
              ],
            ),
          ),
        ));
  }
}
