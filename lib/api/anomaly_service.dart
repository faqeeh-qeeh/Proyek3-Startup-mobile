import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_anomaly.dart';
import '../models/device_classification.dart';
import '../models/quality_report.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class AnomalyService {
  static Future<Map<String, dynamic>> getAnomaliesAndClassification(int deviceId) async {
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
      final List<dynamic> anomalies = data['data']['anomalies']['data'];
      final dynamic classification = data['data']['classification'];
      
      return {
        'anomalies': anomalies.map((json) => DeviceAnomaly.fromJson(json)).toList(),
        'classification': classification != null 
            ? DeviceClassification.fromJson(classification) 
            : null,
      };
    } else {
      throw Exception('Failed to load anomalies and classification');
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
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      return {
        'anomalies_count': data['anomalies_count'],
        'quality_score': data['quality_score'],
        'quality_level': data['quality_level'],
        'quality_stats': data['quality_stats'],
        'classification': data['classification'] != null
            ? DeviceClassification.fromJson(data['classification'])
            : null,
      };
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
      final data = jsonDecode(response.body);
      return QualityReport(
        goodSamples: data['good_samples'] ?? 0,
        fairSamples: data['fair_samples'] ?? 0,
        poorSamples: data['poor_samples'] ?? 0,
        totalSamples: data['total_samples'] ?? 1,
        qualityScore: double.parse((data['quality_score'] ?? 0).toString()),
        qualityLevel: data['quality_level'] ?? 'unknown',
        lastUpdated: DateTime.parse(data['last_updated']),
      );
    } else {
      throw Exception('Failed to load quality report');
    }
  }
}