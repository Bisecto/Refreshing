import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:refreshing_co/repository/auth_service.dart';
import '../model/cafe/cafe_model.dart';
import '../model/product/product_model.dart';


class ProductService {
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';
  final AuthRepository _authService;

  ProductService({required AuthRepository authService}) : _authService = authService;

  // Helper method to get valid token
  Future<String?> _getValidToken() async {
    final tokenResult = await _authService.getValidToken();
    if (tokenResult['success'] == true) {
      return tokenResult['token'];
    }
    return null;
  }

  // Helper method to make authenticated request with auto-retry
  Future<http.Response> _makeAuthenticatedRequest(
      Future<http.Response> Function(String token) request,
      {int maxRetries = 1}
      ) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final token = await _getValidToken();
        if (token == null) {
          throw Exception('No valid token available');
        }

        final response = await request(token);

        // If unauthorized and we haven't retried yet, try to refresh token
        if (response.statusCode == 401 && attempt < maxRetries) {
          print('401 received, attempting token refresh (attempt ${attempt + 1})...');

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

  // Option 1: Keep your current signature but make token optional
  Future<Map<String, dynamic>> getProducts({
    required String cafeId,
    int page = 1,
    int limit = 10,
    String? token, // Made optional
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: {
          'cafeId': cafeId,
          'page': page.toString(),
          'limit': limit.toString(),
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

      final responseData = json.decode(response.body);
      print('Products response: $responseData');

      if (response.statusCode == 200) {
        final products = (responseData['data'] as List?)
            ?.map((e) => ProductModel.fromJson(e))
            .toList() ?? [];

        return {
          'success': true,
          'data': products,
          'meta': responseData['meta'] ?? {},
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch products',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getCafeDetails(
      String cafeId, {
        String? token, // Made optional
      }) async {
    try {
      late http.Response response;

      if (token != null) {
        // Use provided token (backward compatibility)
        response = await http.get(
          Uri.parse('$baseUrl/cafes/$cafeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Use auto-refresh token system
        response = await _makeAuthenticatedRequest(
              (validToken) => http.get(
            Uri.parse('$baseUrl/cafes/$cafeId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $validToken',
            },
          ),
        );
      }

      final responseData = json.decode(response.body);
      print('Cafe details response: $responseData');

      if (response.statusCode == 200) {
        final cafe = CafeModel.fromJson(responseData['data'] ?? responseData);
        return {
          'success': true,
          'data': cafe,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cafe details',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getProductDetails(
      String productId, {
        String? token, // Made optional
      }) async {
    try {
      late http.Response response;

      if (token != null) {
        // Use provided token (backward compatibility)
        response = await http.get(
          Uri.parse('$baseUrl/products/$productId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        // Use auto-refresh token system
        response = await _makeAuthenticatedRequest(
              (validToken) => http.get(
            Uri.parse('$baseUrl/products/$productId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $validToken',
            },
          ),
        );
      }

      final responseData = json.decode(response.body);
      print('Product details response: $responseData');

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(responseData['data'] ?? responseData);
        return {
          'success': true,
          'data': product,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch product details',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  // Option 2: New methods without token parameter (cleaner API)
  Future<Map<String, dynamic>> getProductsAuto({
    required String cafeId,
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
    bool? isAvailable,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products?includeCustomizations=true').replace(
        queryParameters: {
          'cafeId': cafeId,
          'page': page.toString(),
          'limit': limit.toString(),
          if (category != null) 'category': category,
          if (search != null) 'search': search,
          if (isAvailable != null) 'isAvailable': isAvailable.toString(),
        },
      );

      final response = await _makeAuthenticatedRequest(
            (validToken) => http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $validToken',
          },
        ),
      );

      final responseData = json.decode(response.body);
      print('Products response: $responseData');

      if (response.statusCode == 200) {
        final products = (responseData['data'] as List?)
            ?.map((e) => ProductModel.fromJson(e))
            .toList() ?? [];

        return {
          'success': true,
          'data': products,
          'meta': responseData['meta'] ?? {},
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch products',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getCafeDetailsAuto(String cafeId) async {
    try {
      final response = await _makeAuthenticatedRequest(
            (validToken) => http.get(
          Uri.parse('$baseUrl/cafes/$cafeId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $validToken',
          },
        ),
      );

      final responseData = json.decode(response.body);
      print('Cafe details response: $responseData');

      if (response.statusCode == 200) {
        final cafe = CafeModel.fromJson(responseData['data'] ?? responseData);
        return {
          'success': true,
          'data': cafe,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cafe details',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getProductDetailsAuto(String productId) async {
    try {
      final response = await _makeAuthenticatedRequest(
            (validToken) => http.get(
          Uri.parse('$baseUrl/products/$productId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $validToken',
          },
        ),
      );

      final responseData = json.decode(response.body);
      print('Product details response: $responseData');

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(responseData['data'] ?? responseData);
        return {
          'success': true,
          'data': product,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch product details',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred: $e',
      };
    }
  }

  // Utility method to check token validity
  Future<bool> isTokenValid() async {
    final token = await _getValidToken();
    return token != null;
  }

  // Method to manually refresh token
  Future<Map<String, dynamic>> refreshAuthToken() async {
    return await _authService.refreshToken();
  }
}