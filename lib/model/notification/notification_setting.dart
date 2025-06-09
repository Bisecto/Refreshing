// notification_settings_model.dart
import 'package:flutter/material.dart';

class NotificationSettingsModel {
  final String id;
  final String userId;
  final bool allNotifications;
  final bool orderReady;
  final bool paymentSuccessful;
  final bool orderCancelled;
  final bool subscriptionDue;
  final bool subscriptionExpired;
  final bool promotions;
  final bool newProducts;
  final bool specialOffers;
  final bool accountUpdates;
  final bool securityAlerts;
  final bool deliveryUpdates;
  final bool estimatedDelivery;
  final bool reviewReminders;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationSettingsModel({
    required this.id,
    required this.userId,
    required this.allNotifications,
    required this.orderReady,
    required this.paymentSuccessful,
    required this.orderCancelled,
    required this.subscriptionDue,
    required this.subscriptionExpired,
    required this.promotions,
    required this.newProducts,
    required this.specialOffers,
    required this.accountUpdates,
    required this.securityAlerts,
    required this.deliveryUpdates,
    required this.estimatedDelivery,
    required this.reviewReminders,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      allNotifications: json['allNotifications'] ?? false,
      orderReady: json['orderReady'] ?? false,
      paymentSuccessful: json['paymentSuccessful'] ?? false,
      orderCancelled: json['orderCancelled'] ?? false,
      subscriptionDue: json['subscriptionDue'] ?? false,
      subscriptionExpired: json['subscriptionExpired'] ?? false,
      promotions: json['promotions'] ?? false,
      newProducts: json['newProducts'] ?? false,
      specialOffers: json['specialOffers'] ?? false,
      accountUpdates: json['accountUpdates'] ?? false,
      securityAlerts: json['securityAlerts'] ?? false,
      deliveryUpdates: json['deliveryUpdates'] ?? false,
      estimatedDelivery: json['estimatedDelivery'] ?? false,
      reviewReminders: json['reviewReminders'] ?? false,
      emailNotifications: json['emailNotifications'] ?? false,
      pushNotifications: json['pushNotifications'] ?? false,
      smsNotifications: json['smsNotifications'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'allNotifications': allNotifications,
      'orderReady': orderReady,
      'paymentSuccessful': paymentSuccessful,
      'orderCancelled': orderCancelled,
      'subscriptionDue': subscriptionDue,
      'subscriptionExpired': subscriptionExpired,
      'promotions': promotions,
      'newProducts': newProducts,
      'specialOffers': specialOffers,
      'accountUpdates': accountUpdates,
      'securityAlerts': securityAlerts,
      'deliveryUpdates': deliveryUpdates,
      'estimatedDelivery': estimatedDelivery,
      'reviewReminders': reviewReminders,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // For API update requests (exclude id, userId, timestamps)
  Map<String, dynamic> toUpdateJson() {
    return {
      'allNotifications': allNotifications,
      'orderReady': orderReady,
      'paymentSuccessful': paymentSuccessful,
      'orderCancelled': orderCancelled,
      'subscriptionDue': subscriptionDue,
      'subscriptionExpired': subscriptionExpired,
      'promotions': promotions,
      'newProducts': newProducts,
      'specialOffers': specialOffers,
      'accountUpdates': accountUpdates,
      'securityAlerts': securityAlerts,
      'deliveryUpdates': deliveryUpdates,
      'estimatedDelivery': estimatedDelivery,
      'reviewReminders': reviewReminders,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
    };
  }

  NotificationSettingsModel copyWith({
    String? id,
    String? userId,
    bool? allNotifications,
    bool? orderReady,
    bool? paymentSuccessful,
    bool? orderCancelled,
    bool? subscriptionDue,
    bool? subscriptionExpired,
    bool? promotions,
    bool? newProducts,
    bool? specialOffers,
    bool? accountUpdates,
    bool? securityAlerts,
    bool? deliveryUpdates,
    bool? estimatedDelivery,
    bool? reviewReminders,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationSettingsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      allNotifications: allNotifications ?? this.allNotifications,
      orderReady: orderReady ?? this.orderReady,
      paymentSuccessful: paymentSuccessful ?? this.paymentSuccessful,
      orderCancelled: orderCancelled ?? this.orderCancelled,
      subscriptionDue: subscriptionDue ?? this.subscriptionDue,
      subscriptionExpired: subscriptionExpired ?? this.subscriptionExpired,
      promotions: promotions ?? this.promotions,
      newProducts: newProducts ?? this.newProducts,
      specialOffers: specialOffers ?? this.specialOffers,
      accountUpdates: accountUpdates ?? this.accountUpdates,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      deliveryUpdates: deliveryUpdates ?? this.deliveryUpdates,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      reviewReminders: reviewReminders ?? this.reviewReminders,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods for UI grouping
  List<NotificationSetting> get orderSettings => [
    NotificationSetting(
      key: 'orderReady',
      title: 'When orders are ready',
      description: 'Get notified when your order is ready for pickup',
      value: orderReady,
      icon: Icons.restaurant_menu,
      category: 'Orders',
    ),
    NotificationSetting(
      key: 'paymentSuccessful',
      title: 'When payment is successful',
      description: 'Confirmation when your payment goes through',
      value: paymentSuccessful,
      icon: Icons.payment,
      category: 'Orders',
    ),
    NotificationSetting(
      key: 'orderCancelled',
      title: 'When order is cancelled',
      description: 'Alerts about order cancellations',
      value: orderCancelled,
      icon: Icons.cancel,
      category: 'Orders',
    ),
    NotificationSetting(
      key: 'deliveryUpdates',
      title: 'Delivery updates',
      description: 'Real-time delivery status updates',
      value: deliveryUpdates,
      icon: Icons.local_shipping,
      category: 'Orders',
    ),
    NotificationSetting(
      key: 'estimatedDelivery',
      title: 'Estimated delivery time',
      description: 'Updates on estimated delivery times',
      value: estimatedDelivery,
      icon: Icons.schedule,
      category: 'Orders',
    ),
  ];

  List<NotificationSetting> get subscriptionSettings => [
    NotificationSetting(
      key: 'subscriptionDue',
      title: 'When subscription is due',
      description: 'Reminders about upcoming subscription payments',
      value: subscriptionDue,
      icon: Icons.calendar_today,
      category: 'Subscription',
    ),
    NotificationSetting(
      key: 'subscriptionExpired',
      title: 'When subscription expires',
      description: 'Alerts when your subscription has expired',
      value: subscriptionExpired,
      icon: Icons.error_outline,
      category: 'Subscription',
    ),
  ];

  List<NotificationSetting> get marketingSettings => [
    NotificationSetting(
      key: 'promotions',
      title: 'Promotions',
      description: 'Special deals and promotional offers',
      value: promotions,
      icon: Icons.local_offer,
      category: 'Marketing',
    ),
    NotificationSetting(
      key: 'newProducts',
      title: 'New products',
      description: 'Updates about new menu items and products',
      value: newProducts,
      icon: Icons.new_releases,
      category: 'Marketing',
    ),
    NotificationSetting(
      key: 'specialOffers',
      title: 'Special offers',
      description: 'Limited-time offers and discounts',
      value: specialOffers,
      icon: Icons.star,
      category: 'Marketing',
    ),
  ];

  List<NotificationSetting> get accountSettings => [
    NotificationSetting(
      key: 'accountUpdates',
      title: 'Account updates',
      description: 'Changes to your account information',
      value: accountUpdates,
      icon: Icons.account_circle,
      category: 'Account',
    ),
    NotificationSetting(
      key: 'securityAlerts',
      title: 'Security alerts',
      description: 'Important security-related notifications',
      value: securityAlerts,
      icon: Icons.security,
      category: 'Account',
    ),
    NotificationSetting(
      key: 'reviewReminders',
      title: 'Review reminders',
      description: 'Reminders to review your orders',
      value: reviewReminders,
      icon: Icons.rate_review,
      category: 'Account',
    ),
  ];

  List<NotificationSetting> get channelSettings => [
    NotificationSetting(
      key: 'emailNotifications',
      title: 'Email notifications',
      description: 'Receive notifications via email',
      value: emailNotifications,
      icon: Icons.email,
      category: 'Channels',
    ),
    NotificationSetting(
      key: 'pushNotifications',
      title: 'Push notifications',
      description: 'Receive push notifications on your device',
      value: pushNotifications,
      icon: Icons.notifications,
      category: 'Channels',
    ),
    NotificationSetting(
      key: 'smsNotifications',
      title: 'SMS notifications',
      description: 'Receive notifications via text message',
      value: smsNotifications,
      icon: Icons.sms,
      category: 'Channels',
    ),
  ];
}

class NotificationSetting {
  final String key;
  final String title;
  final String description;
  final bool value;
  final IconData icon;
  final String category;

  NotificationSetting({
    required this.key,
    required this.title,
    required this.description,
    required this.value,
    required this.icon,
    required this.category,
  });
}