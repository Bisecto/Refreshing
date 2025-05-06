import 'dart:convert';

import 'package:flutter/material.dart';

import '../view/important_pages/not_found_page.dart';


class AppRouter {
  ///All route name

  /// ONBOARDING SCREEEN
  static const String splashScreen = '/';
  static const String onBoardingScreen = "/on-boarding-screen";

  /// AUTH SCREENS
  static const String signInScreen = "/sign-in-page";
  static const String signUpScreen = "/sign-up-page";

  //static const String otpVerification = "/otp-page";
  static const String signInWIthAccessPinBiometrics =
      "/sign-in-wIth-access-pin-biometrics";

  ///IMPORTANT SCREENS
  static const String noInternetScreen = "/no-internet";

  ///LANDING PAGE LandingPage
  static const String landingPage = "/landing-page";



  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // case splashScreen:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case onBoardingScreen:
      //   return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      // case signUpScreen:
      //   return MaterialPageRoute(builder: (_) => const SignUpScreen());
      //
      // case signInScreen:
      //   return MaterialPageRoute(builder: (_) => const SignInScreen());
      //
      // case landingPage:
      //   return MaterialPageRoute(
      //     builder: (_) =>  const LandingPage(),
      //
      //   );


      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
