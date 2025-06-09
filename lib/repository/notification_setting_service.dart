import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/notification/notification_setting.dart';
import '../res/apis.dart';

class NotificationSettingsService {
  


  Future<NotificationSettingsModel> getNotificationSettings(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${AppApis.appBaseUrl}/api/v1/notifications/settings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
