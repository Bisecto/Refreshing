import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/setting_pages/notification_screen.dart';
import 'package:refreshing_co/view/app_screens/setting_pages/profile_screen.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../auth/sign_in_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Settings options list
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: ProfilePage());
                      },
                      child: _buildSettingsOption('Profile')),
                  _buildSettingsOption('Payment Methods'),
                  InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: NotificationSettingsScreen());
                      },
                      child: _buildSettingsOption('Notification')),
                  _buildSettingsOption('Settings'),
                  _buildSettingsOption('Feedback'),
                  _buildSettingsOption('Legal'),
                  _buildSettingsOption('Help Center'),
                ],
              ),
            ),

            SizedBox(height: 30),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSignedOut) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                        (route) => false,
                  );
                }
              },
              child: FormButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                text: "Logout",
                bgColor: AppColors.grey.withOpacity(0.5),
                textColor: AppColors.black,
              ),
            ),
            // Logout button

          ],
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: AppColors.appMainColor),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildSettingsOption(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: title,
          size: 18,
        ),
      ),
    );
  }
}
