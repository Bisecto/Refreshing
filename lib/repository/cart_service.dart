import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/cart_model.dart';

class CartService {

  static const String baseUrl = 'https://api.refreshandco.com/api/v1';

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    required   final List<Map<String, String>> customizations,
    required String token
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
      print( response.headers);
      print( response.statusCode);
      print( response.body);
      print( response.headersSplitValues);

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
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }
  Future<CartResponse> getCart({    required String token
  }) async {
    try {
      // Replace with your actual HTTP client
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers:  {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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


  Future<Map<String, dynamic>> getCartCount({    required String token
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart/count'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'count': responseData['count'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cart count',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
    required String token

  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/cart/$itemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'quantity': quantity,
        }),
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
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> removeCartItem(String itemId,{    required String token
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
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }


  Future<Map<String, dynamic>> clearCart({    required String token
  }) async {
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