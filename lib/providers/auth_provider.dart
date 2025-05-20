import 'package:flutter/material.dart';
import '../models/client.dart';
import '../utils/shared_prefs.dart';

class AuthProvider with ChangeNotifier {
  Client? _client;
  String? _token;

  Client? get client => _client;
  String? get token => _token;

  Future<void> loadUser() async {
    _client = await SharedPrefs.getClient();
    _token = await SharedPrefs.getToken();
    notifyListeners();
  }

  Future<void> setUser(Client client, String token) async {
    _client = client;
    _token = token;
    await SharedPrefs.saveClient(client);
    await SharedPrefs.saveToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    _client = null;
    _token = null;
    await SharedPrefs.clear();
    notifyListeners();
  }
}