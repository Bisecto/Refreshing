
// notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refreshing_co/res/apis.dart';

import '../model/notification/notification_response.dart';
import '../model/notification/unread_count.dart';
import 'auth_service.dart';

class NotificationService {
  final AuthRepository _authService;
  NotificationService({required AuthRepository authService}) : _authService = authService;
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
  Future<String?> _getValidToken() async {
    final tokenResult = await _authService.getValidToken();
    if (tokenResult['success'] == true) {
      return tokenResult['token'];
    }
    return null;
  }
  Future<http.Response> _makeAuthenticatedRequest(
      Future<http.Response> Function(String token) request, {
        int maxRetries = 1,
      }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final token = await _getValidToken();
        if (token == null) {
          throw Exception('No valid token available');
        }

        final response = await request(token);

        // If unauthorized and we haven't retried yet, try to refresh token
        if (response.statusCode == 401 && attempt < maxRetries) {
          print(
            '401 received, attempting token refresh (attempt ${attempt + 1})...',
          );

          final refreshResult = await _authService.refreshToken();
          if (refreshResult['success'] == true) {
            print('Token refreshed successfully, retrying request...');
            continue; // Retry with new token
          } else {
            print('Token refresh failed: ${refreshResult['message']}');
            break; // Don't retry if refresh failed
          }
        }

        return response;
      } catch (e) {
        if (attempt == maxRetries) rethrow;
        print('Request failed (attempt ${attempt + 1}): $e');
      }
    }

    throw Exception('Request failed after $maxRetries retries');
  }


  Future<NotificationResponse> getNotifications(String token) async {
    try {
      final uri =
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications');
      late http.Response response;

      if (token != null) {
        // Use provided token (backward compatibility)
        response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Use auto-refresh token system
        response = await _makeAuthenticatedRequest(
              (validToken) => http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $validToken',
            },
          ),
        );
      }

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
      final uri =
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/unread-count');
      late http.Response response;

      if (token != null) {
        // Use provided token (backward compatibility)
        response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Use auto-refresh token system
        response = await _makeAuthenticatedRequest(
              (validToken) => http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $validToken',
            },
          ),
        );
      }

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