import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/notification/notification_setting.dart';
import '../res/apis.dart';
import 'auth_service.dart';

class NotificationSettingsService {
  final AuthRepository _authService;
  NotificationSettingsService({required AuthRepository authService}) : _authService = authService;
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

  Future<String?> _getValidToken() async {
    final tokenResult = await _authService.getValidToken();
    if (tokenResult['success'] == true) {
      return tokenResult['token'];
    }
    return null;
  }

  Future<NotificationSettingsModel> getNotificationSettings(String token) async {
    try {
      final uri=
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/settings');
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
        return NotificationSettingsModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load notification settings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> updateNotificationSettings(
    NotificationSettingsModel settings,String token
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/settings'),
        headers: {...{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      }, 'Content-Type': 'application/json'},
        body: json.encode(settings.toUpdateJson()),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Settings updated successfully',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update settings',
        };
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
