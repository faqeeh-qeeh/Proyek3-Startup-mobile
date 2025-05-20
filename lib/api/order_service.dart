import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../models/product.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class OrderService {
  static Future<List<Order>> getOrders() async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> orders = data['data'];
      return orders.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<Order> createOrder(Product product) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/client/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': product.id,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Order.fromJson(data['order']);
    } else {
      throw Exception('Failed to create order');
    }
  }

  static Future<Order> getOrderDetails(int orderId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/orders/$orderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Order.fromJson(data);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  static Future<Map<String, dynamic>> createPayment(Order order) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/client/orders/${order.id}/payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment');
    }
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(Order order) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/orders/${order.id}/check-status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}