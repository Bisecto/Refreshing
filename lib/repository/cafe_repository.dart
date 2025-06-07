import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/cafe/adons.dart';
import '../model/cafe/cafe_model.dart';

class CafeService {
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';

  Future<Map<dynamic, dynamic>> searchCafes(CafeSearchRequest request,String token) async {
    try {
      print(request.toJson());
      final uri = Uri.parse('$baseUrl/search/all').replace(
        queryParameters: request.toJson().map((key, value) => MapEntry(key, value.toString())),
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
      final response = await http.get(
        Uri.parse('$baseUrl/search/filter-options'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
