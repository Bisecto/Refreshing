import 'package:http/http.dart' as http;
import 'package:refreshing_co/repository/auth_service.dart';
import 'dart:convert';

class ApiInterceptor {
  final AuthRepository authRepository;

  ApiInterceptor(this.authRepository);

  Future<http.Response> get(String url, {Map<String, String>? additionalHeaders}) async {
    return await _makeRequest(() async => http.get(
        Uri.parse(url),
        headers: await _getHeaders(additionalHeaders),
    ));
  }

  Future<http.Response> post(String url, {Object? body, Map<String, String>? additionalHeaders}) async {
    return await _makeRequest(() async => http.post(
        Uri.parse(url),
        headers: await _getHeaders(additionalHeaders),
      body: body,
    ));
  }

  Future<http.Response> patch(String url, {Object? body, Map<String, String>? additionalHeaders}) async {
    return await _makeRequest(() async => http.patch(
        Uri.parse(url),
        headers: await _getHeaders(additionalHeaders),
      body: body,
    ));
  }

  Future<http.Response> delete(String url, {Map<String, String>? additionalHeaders}) async {
    return await _makeRequest(() async => http.delete(
        Uri.parse(url),
        headers: await _getHeaders(additionalHeaders),
    ));
  }

  Future<http.Response> _makeRequest(Future<http.Response> Function() request) async {
    final response = await request();

    // If unauthorized, try to refresh token and retry
    if (response.statusCode == 401) {
      print('401 received, attempting token refresh...');

      final refreshResult = await authRepository.refreshToken();
      if (refreshResult['success'] == true) {
        print('Token refreshed, retrying request...');
        return await request(); // Retry with new token
      } else {
        print('Token refresh failed, request failed');
      }
    }

    return response;
  }

  Future<Map<String, String>> _getHeaders(Map<String, String>? additionalHeaders) async {
    final tokenResult = await authRepository.getValidToken();

    final headers = {
      'Content-Type': 'application/json',
      ...?additionalHeaders,
    };

    if (tokenResult['success'] == true) {
      headers['Authorization'] = 'Bearer ${tokenResult['token']}';
    }

    return headers;
  }
}