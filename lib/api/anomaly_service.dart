import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_anomaly.dart';
import '../models/quality_report.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class AnomalyService {
  static Future<List<DeviceAnomaly>> getAnomalies(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/anomalies'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> anomalies = data['data']['data'];
      return anomalies.map((json) => DeviceAnomaly.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load anomalies');
    }
  }

  static Future<Map<String, dynamic>> detectAnomalies(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/detect-anomalies'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to detect anomalies');
    }
  }

  static Future<QualityReport> getRecentQuality(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/recent-anomalies'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return QualityReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load quality report');
    }
  }
}