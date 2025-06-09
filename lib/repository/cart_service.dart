import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/cart_model.dart';
import 'auth_service.dart';

class CartService {
  final AuthRepository _authService;

  CartService({required AuthRepository authService})
    : _authService = authService;
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';

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
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    required final List<Map<String, String>> customizations,
    required String token,
  }) async {
    try {
      print(customizations);
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'productId': productId,
          'quantity': quantity,
          'customizations': customizations,
        }),
      );
      print(response.headers);
      print(response.statusCode);
      print(response.body);
      print(response.headersSplitValues);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': 'Item added to cart successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to add item to cart',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<CartResponse> getCart({required String token}) async {
    try {
      // Replace with your actual HTTP client
      final uri =
        Uri.parse('$baseUrl/cart');
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
        return CartResponse.fromJson(data);
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getCartCount({required String token}) async {
    try {
      final uri =
        Uri.parse('$baseUrl/cart/count');
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
        return {'success': true, 'count': responseData['count'] ?? 0};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cart count',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
    required String token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/cart/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'quantity': quantity}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': 'Cart item updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update cart item',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> removeCartItem(
    String itemId, {
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Item removed from cart successfully',
        };
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to remove cart item',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  Future<Map<String, dynamic>> clearCart({required String token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
