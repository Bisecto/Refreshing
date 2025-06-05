import 'dart:io';
import 'package:encrypt/encrypt.dart' as prefix0;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/foundation/key.dart' as kk;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:refreshing_co/utills/shared_preferences.dart';

import '../res/app_router.dart';
import '../res/sharedpref_key.dart';
import '../view/auth/sign_in_screen.dart';
import '../view/important_pages/dialog_box.dart';
import 'app_navigator.dart';

class AppUtils {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void debuglog(object) {
    if (kDebugMode) {
      print(object.toString());
      // debugPrint(object.toString());
    }
  }


  Future<Placemark> getAddressFromLatLng(Position position) async {
    try {


      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // String address =
        //     '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
        return place;
      } else {
        return Placemark();
        print('No address found');
      }
    } catch (e) {
      return Placemark();

    //  print('Error: $e');
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied.');
    }


    // Get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  openApp(context) async {
    bool isFirstOpen =
        (await SharedPref.getBool(SharedPrefKey.isFirstOpenKey)) ?? true;
    String userData = await SharedPref.getString(SharedPrefKey.userDataKey);
    print(userData);
    print(8);

    if (!isFirstOpen) {
      print(1);
      if (userData.isNotEmpty ) {
        print(3);

        // Future.delayed(const Duration(seconds: 3), () {
        //   AppNavigator.pushAndRemovePreviousPages(context,
        //       page: SignInWIthAccessPinBiometrics(userName: firstame));
        // });
      } else {
        print(4);

        Future.delayed(const Duration(seconds: 3), () {
          AppNavigator.pushAndRemovePreviousPages(
            context,
            page: const SignInScreen(),
          );
        });
      }
    } else {
      print(15);

      await SharedPref.putBool(SharedPrefKey.isFirstOpenKey, false);
      Future.delayed(const Duration(seconds: 3), () {
        AppNavigator.pushAndRemovePreviousPages(
          context,
          page: const SignInScreen(),
        );
      });
    }
  }

  logout() async {
    SharedPref.remove(SharedPrefKey.userDataKey);

    SharedPref.remove(SharedPrefKey.userDataKey);
    SharedPref.remove(SharedPrefKey.refreshTokenKey);
    SharedPref.remove(SharedPrefKey.hashedAccessPinKey);
    SharedPref.remove(SharedPrefKey.biometricKey);
  }

  ///Future<String?>
  static getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  void copyToClipboard(textToCopy, context) {
    Clipboard.setData(ClipboardData(text: "${textToCopy}"));
    MSG.snackBar(context, "$textToCopy copied");
    // You can also show a snackbar or any other feedback to the user.
    print('Text copied to clipboard: $textToCopy');
  }

  static Size deviceScreenSize(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static DateTime timeToDateTime(TimeOfDay time, [DateTime? date]) {
    final newDate = date ?? DateTime.now();
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      time.hour,
      time.minute,
    );
  }

  static String formatString({required String data}) {
    if (data.isEmpty) return data;
    String firstLetter = data[0].toUpperCase();
    String remainingString = data.substring(1);
    return firstLetter + remainingString;
  }

  // static String formatComplexDate({required String dateTime}) {
  //   DateTime parseDate = DateFormat("dd-MM-yyyy").parse(dateTime);
  //   var inputDate = DateTime.parse(parseDate.toString());
  //   var outputFormat = DateFormat('d MMMM, yyyy');
  //   var outputDate = outputFormat.format(inputDate);
  //
  //   return outputDate;
  // }

  static String convertString(dynamic data) {
    if (data is String) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      return data[0];
    } else {
      return data[0];
    }
  }

  static String formateSimpleDate({String? dateTime}) {
    var inputDate = DateTime.parse(dateTime!);
    var outputFormat = DateFormat('yyyy MMM d, hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  // static bool isPhoneNumber(String s) {
  //   if (s.length > 16 || s.length < 11) return false;
  //   return hasMatch(s, r'^(?:[+0][1-9])?[0-9]{10,12}$');
  // }

  // static final dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  // static final dateFormat = DateFormat('dd MMM, yyyy');
  // static final timeFormat = DateFormat('hh:mm a');
  // static final apiDateFormat = DateFormat('yyyy-MM-dd');
  // static final utcTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  // static final dayOfWeekFormat = DateFormat('EEEEE', 'en_US');
}
