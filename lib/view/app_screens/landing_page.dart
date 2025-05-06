import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:refreshing_co/view/app_screens/account.dart';
import 'package:refreshing_co/view/app_screens/cart_screen.dart';
import 'package:refreshing_co/view/app_screens/reward_screen.dart';
import 'package:refreshing_co/view/app_screens/home_screen.dart';
import 'package:refreshing_co/view/app_screens/settings.dart';

import '../../main.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../../utills/shared_preferences.dart';
import '../important_pages/no_internet.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  List<Widget> landPageScreens = [];
  bool _connected = true;

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  bool isNotification = false;
  @override
  void initState() {
    // TODO: implement initState


    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivity);

    landPageScreens = [
      const HomeScreen(),
      const CartScreen(),
      const RewardScreen(),
       AccountScreen(),
       SettingsScreen()
    ];
    super.initState();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _handleConnectivity(connectivityResult);
  }

  void _handleConnectivity(ConnectivityStatus result) {
    if (result == ConnectivityStatus.none) {
      debugPrint("No network");
      setState(() {
        _connected = false;
      });
    } else {
      debugPrint("Network connected");
      setState(() {
        _connected = true;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Provider
    //     .of<CustomThemeState>(context)
    //     .adaptiveThemeMode;

    return _connected
        ? Scaffold(
          backgroundColor: AppColors.white,

          body: IndexedStack(
            children: [
              landPageScreens[_currentIndex],
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            //fixedColor:   AppColors.white,
            showUnselectedLabels: true,
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.appMainColor,
            unselectedItemColor:  AppColors.lightDivider,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.home,
                  color: _currentIndex == 0
                      ? AppColors.appMainColor
                      : AppColors.black,
                ), //Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppIcons.bag,
                    color: _currentIndex == 1
                        ? AppColors.appMainColor
                        :  AppColors.black),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.goft,
                  color: _currentIndex == 2
                      ? AppColors.appMainColor
                      :  AppColors.black,
                ), //Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.user,
                  color: _currentIndex == 3
                      ? AppColors.appMainColor
                      : AppColors.black,
                ), //Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.settings,
                  color: _currentIndex == 4
                      ? AppColors.appMainColor
                      :  AppColors.black,
                ), //Icon(Icons.home),
                label: '',
              ),
            ],
          ),

        )
        : No_internet_Page(onRetry: _checkConnectivity);
  }
}
