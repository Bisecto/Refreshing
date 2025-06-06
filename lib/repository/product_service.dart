import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cafe/cafe_model.dart';
import '../model/product/product_model.dart';


class ProductService {
  static const String baseUrl = 'https://api.refreshandco.com/api/v1';

  Future<Map<String, dynamic>> getProducts({
    required String cafeId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: {
          'cafeId': cafeId,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      final responseData = json.decode(response.body);
print(responseData);
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
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> getCafeDetails(String cafeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cafes/$cafeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final cafe = CafeModel.fromJson(responseData);
        return {
          'success': true,
          'data': cafe,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch cafe details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      final responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(responseData);
        return {
          'success': true,
          'data': product,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch product details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }
}
