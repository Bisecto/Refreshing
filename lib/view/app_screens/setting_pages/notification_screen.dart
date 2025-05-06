import 'package:flutter/material.dart';
import 'package:refreshing_co/res/app_colors.dart';
import 'package:refreshing_co/view/app_screens/cart_app_bar/cart_app_bar.dart';
import 'package:refreshing_co/view/widgets/app_custom_text.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool allNotifications = true;
  bool ordersReady = true;
  bool paymentSuccessful = true;
  bool orderCancelled = true;
  bool subscriptionDue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification message at the top
              CartAppBar(),
              AppBar(
                title: TextStyles.textHeadings(textValue: 'Notifications',textSize: 20),
                centerTitle: true,
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We may still send you notifications outside your notification settings',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Notification Settings List
              buildSwitchTile(
                'All notifications',
                allNotifications,
                (value) {
                  setState(() {
                    allNotifications = value;
                  });
                },
              ),
              buildSwitchTile(
                'When orders are ready',
                ordersReady,
                (value) {
                  setState(() {
                    ordersReady = value;
                  });
                },
              ),
              buildSwitchTile(
                'When payment is successful',
                paymentSuccessful,
                (value) {
                  setState(() {
                    paymentSuccessful = value;
                  });
                },
              ),
              buildSwitchTile(
                'When order is cancelled',
                orderCancelled,
                (value) {
                  setState(() {
                    orderCancelled = value;
                  });
                },
              ),
              buildSwitchTile(
                'When your subscription is due',
                subscriptionDue,
                (value) {
                  setState(() {
                    subscriptionDue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the Switch ListTile widget
  Widget buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SwitchListTile(
          activeColor: Colors.blue,
          title: CustomText(text: title,size: 16,weight:FontWeight.bold,color: AppColors.black,),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
