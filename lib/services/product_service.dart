import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:babyshophub/models/product.dart';

class ProductService {
  final String baseUrl = 'http://127.0.0.1:5000/api/products';

  Future<List<ProductData>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
        // stores the JSON data from the response body into a list called jsonData
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Convert jsonData into List<ProductData> 
      return jsonData.map((json) => ProductData.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load products');
    }
  }
}