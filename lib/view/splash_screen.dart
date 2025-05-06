import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void dispose() {
    // Reset to default style when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark, // black icons
      statusBarBrightness: Brightness.light,    // iOS
    ));
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appMainColor,
        statusBarIconBrightness: Brightness.light, // white icons
        statusBarBrightness: Brightness.dark,       // iOS
      ),
      child: Scaffold(
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
          )),
    );
  }
}
