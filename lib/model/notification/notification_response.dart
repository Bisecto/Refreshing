import 'notification_model.dart';

class NotificationResponse {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int unreadCount;

  NotificationResponse({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((notification) => NotificationModel.fromJson(notification as Map<String, dynamic>))
          .toList() ?? [],
      totalCount: json['totalCount'] ?? 0,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((notification) => notification.toJson()).toList(),
      'totalCount': totalCount,
      'unreadCount': unreadCount,
    };
  }
}
