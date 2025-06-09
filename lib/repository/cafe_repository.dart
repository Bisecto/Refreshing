import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/cafe/adons.dart';
import '../model/cafe/cafe_model.dart';
import 'auth_service.dart';

class CafeService {
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';
  final AuthRepository _authService;
  CafeService({required AuthRepository authService}) : _authService = authService;

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
  Future<Map<dynamic, dynamic>> searchCafes(CafeSearchRequest request,String token) async {
    try {
      print(request.toJson());
      final uri = Uri.parse('$baseUrl/search/all').replace(
        queryParameters: request.toJson().map((key, value) => MapEntry(key, value.toString())),
      );

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
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print(responseData['cafes']);
        final cafes = (responseData['cafes'] as List?)
            ?.map((e) => CafeModel.fromJson(e))
            .toList() ?? [];

        return {
          'success': true,
          'data': cafes,
         // 'totalResults': responseData['totalResults'] ?? {},
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cafes',
        };
      }
    } catch (e) {
      print(e);

      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> getFilterOptions(String token) async {
    try {
      final uri =
      Uri.parse('$baseUrl/search/filter-options');


    //  final responseData = json.decode(response.body);
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
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final filterOptions = FilterOptionsModel.fromJson(responseData);
        return {
          'success': true,
          'data': filterOptions,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch filter options',
        };
      }
    } catch (e) {
      print(e);

      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(String cafeId,String token) async {
    try {
      print('$baseUrl/cafes/$cafeId/favorites');
      final response = await http.post(
        Uri.parse('$baseUrl/cafes/$cafeId/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'id': cafeId}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Favorite updated successfully',
          'isFavorite': responseData['isFavorite'] ?? false,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update favorite',
        };
      }
    } catch (e) {
      print(e);

      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> getNearbyCafes({
    required double latitude,
    required double longitude,
    double? radius,
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search/nearby').replace(
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          if (radius != null) 'radius': radius.toString(),
        },
      );
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
      // final response = await http.get(
      //   uri,
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   },
      // );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final cafes = (responseData['data'] as List?)
            ?.map((e) => CafeModel.fromJson(e))
            .toList() ?? [];

        return {
          'success': true,
          'data': cafes,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch nearby cafes',
        };
      }
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }
}
