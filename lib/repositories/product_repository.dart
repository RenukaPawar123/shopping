import 'dart:convert';
 import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductRepository {
  final http.Client httpClient;
  final String _baseUrl = 'https://dummyjson.com';

  ProductRepository({required this.httpClient});

  Future<List<Product>> fetchProducts({int limit = 10, int skip = 0}) async {
    final response = await httpClient.get(
      Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List;
      return products.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<int> getTotalProducts() async {
    final response = await httpClient.get(
      Uri.parse('$_baseUrl/products?limit=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['total'] as int;
    } else {
      throw Exception('Failed to get total products');
    }
  }
}

