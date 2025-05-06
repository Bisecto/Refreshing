import 'package:flutter/material.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/utills/app_navigator.dart';
import 'package:refreshing_co/view/app_screens/setting_pages/notification_screen.dart';
import 'package:refreshing_co/view/app_screens/setting_pages/profile_screen.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';
import 'package:refreshing_co/view/widgets/form_button.dart';

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

            // Logout button
            FormButton(
              onPressed: () {},
              text: "Logout",
              bgColor: AppColors.grey.withOpacity(0.5),
              textColor: AppColors.black,
            ),
          ],
        ),
      ),
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
