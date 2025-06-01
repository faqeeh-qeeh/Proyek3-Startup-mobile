import 'package:shared_preferences/shared_preferences.dart';
import '../models/client.dart';
import 'dart:convert'; 

class SharedPrefs {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveClient(Client client) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('client', jsonEncode(client.toJson()));
  }

  static Future<Client?> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    final clientJson = prefs.getString('client');
    if (clientJson != null) {
      return Client.fromJson(jsonDecode(clientJson));
    }
    return null;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  // Add these to your existing SharedPrefs class
// lib/utils/shared_prefs.dart - Add these methods to your existing SharedPrefs class

// Add these methods to your existing SharedPrefs class:

static Future<void> saveThemeMode(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
}

static Future<bool?> getThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode');
}
}
