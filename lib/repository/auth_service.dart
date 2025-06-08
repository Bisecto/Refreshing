import 'dart:convert';

import 'package:jwt_decode/jwt_decode.dart';

import '../res/apis.dart';
import '../res/app_strings.dart';
import 'package:http/http.dart' as http;

import '../res/sharedpref_key.dart';
import '../utills/app_utils.dart';
import '../utills/shared_preferences.dart';

class AuthRepository {
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';

  bool isTokenExpired(String token) {
    try {
      final Map<String, dynamic> payload = Jwt.parseJwt(token);
      final int exp = payload['exp'] ?? 0;
      final DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
        exp * 1000,
      );
      final DateTime now = DateTime.now();
      print(12345);
      // Check if token expires within 5 minutes
      final Duration timeUntilExpiry = expiryDate.difference(now);
      print(timeUntilExpiry.inMinutes <= 5);
      return timeUntilExpiry.inMinutes <= 5;
    } catch (e) {
      print('Error parsing token: $e');
      return true; // Assume expired if we can't parse
    }
  }

  // Validate token with server

  // Refresh token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await SharedPref.getString(
        SharedPrefKey.refreshTokenKey,
      );

      if (refreshToken.isEmpty) {
        return {'success': false, 'message': 'No refresh token available'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
        body: json.encode({'refreshToken': refreshToken}),
      );
      print(response.body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final newAccessToken = responseData['accessToken'];
        final newRefreshToken = responseData['refreshToken'];
        final userData = responseData['user'];

        // Save new tokens
        await SharedPref.putString(SharedPrefKey.authTokenKey, newAccessToken);
        if (newRefreshToken != null) {
          await SharedPref.putString(
            SharedPrefKey.refreshTokenKey,
            newRefreshToken,
          );
        }

        // Update user data if provided
        if (userData != null) {
          await SharedPref.putString(
            SharedPrefKey.userDataKey,
            json.encode({'user': userData}),
          );
        }

        return {
          'success': true,
          'accessToken': newAccessToken,
          'refreshToken': newRefreshToken,
          'user': userData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Token refresh failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error during token refresh',
      };
    }
  }

  // Enhanced method to get valid token (with refresh if needed)
  Future<Map<String, dynamic>> getValidToken() async {
    try {
      String token = await SharedPref.getString(SharedPrefKey.authTokenKey);
      print(token);
      if (token.isEmpty) {
        return {'success': false, 'message': 'No token available'};
      }

      // Check if token is expired or about to expire

      if (isTokenExpired(token)) {
        print('Token is expired or about to expire, attempting refresh...');

        final refreshResult = await refreshToken();
        if (refreshResult['success'] == true) {
          token = refreshResult['accessToken'];
          print('Token refreshed successfully');
          return {
            'success': true,
            'token': token,
            'refreshed': true,
            'user': refreshResult['user'],
          };
        } else {
          return {
            'success': true,
            'token': token,
            'refreshed': false,
            'user': refreshResult['user'],
          };
        }
      } else if (!isTokenExpired(token)) {
        return {'success': true, 'token': token, 'refreshed': false};
      } else {
        print('Server validation failed, attempting refresh...');
        final refreshResult = await refreshToken();
        if (refreshResult['success'] == true) {
          return {
            'success': true,
            'token': refreshResult['accessToken'],
            'refreshed': true,
            'user': refreshResult['user'],
          };
        } else {
          return {
            'success': false,
            'message': 'Token validation and refresh failed',
          };
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Error getting valid token: $e'};
    }
  }

  Future<http.Response> authPostRequest(
    Map<String, String> data,
    String apiUrl,
  ) async {
    var response = await http.post(Uri.parse(apiUrl), body: data);
    AppUtils().debuglog(apiUrl + response.statusCode.toString());
    AppUtils().debuglog(response.body);

    return response;
  }

  Future<http.Response> authPostRequestWithToken(
    String token,
    Map<String, String> data,
    String apiUrl,
  ) async {
    var headers = {'Authorization': 'Bearer $token'};
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: data,
    );
    // AppUtils().debuglog(apiUrl+response.statusCode.toString());
    // AppUtils().debuglog(response.body);
    return response;
  }

  Future<http.Response> authGetRequest(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
    var headers = {
      //  'x-access-token': accessToken,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(user),
    );
    AppUtils().debuglog(apiUrl + response.statusCode.toString());
    AppUtils().debuglog(response.body);
    return response;
  }
}
