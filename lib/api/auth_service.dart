import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(
      String fullName,
      String username,
      String email,
      String whatsappNumber,
      String gender,
      String address,
      String birthDate,
      String password,
      String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/client/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'username': username,
          'email': email,
          'whatsapp_number': whatsappNumber,
          'gender': gender,
          'address': address,
          'birth_date': birthDate,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await SharedPrefs.saveToken(data['token']);
        await SharedPrefs.saveClient(Client.fromJson(data['client']));
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/client/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': login,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await SharedPrefs.saveToken(data['token']);
        await SharedPrefs.saveClient(Client.fromJson(data['client']));
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': jsonDecode(response.body)};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<void> logout() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      await http.post(
        Uri.parse('${Constants.apiUrl}/client/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }
    await SharedPrefs.clear();
  }
}