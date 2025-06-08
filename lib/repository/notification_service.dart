
// notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refreshing_co/res/apis.dart';

import '../model/notification/notification_response.dart';
import '../model/notification/unread_count.dart';

class NotificationService {
  // final String baseUrl;
  // final Map<String, String> headers;

  // NotificationService({
  //   // required this.baseUrl,
  //   // required this.headers,
  // });

  // Map<String, String> headers= {
  // 'Authorization': 'Bearer your-auth-token',
  // 'Content-Type': 'application/json',
  // };
  Future<NotificationResponse> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NotificationResponse.fromJson(data);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<UnreadCountResponse> getUnreadCount(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/unread-count'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UnreadCountResponse.fromJson(data);
      } else {
        throw Exception('Failed to load unread count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> markAllAsRead(String token) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/mark-all-read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId,String token) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}