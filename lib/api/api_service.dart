import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class ApiService {
  static Future<List<Product>> getProducts() async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}