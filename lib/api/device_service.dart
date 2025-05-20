import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_device.dart';
import '../models/device_monitoring.dart';
import '../models/relay_status.dart';
import '../utils/constants.dart';
import '../utils/shared_prefs.dart';

class DeviceService {
  static Future<List<ClientDevice>> getDevices() async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['data'];
        return data.map((json) => ClientDevice.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load devices');
      }
    } else {
      throw Exception('Failed to load devices: ${response.statusCode}');
    }
  }

  static Future<DeviceMonitoring> getLatestMonitoringData(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/latest-data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return DeviceMonitoring.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load monitoring data');
    }
  }

  static Future<List<DeviceMonitoring>> getMonitoringHistory(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/monitoring-data'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => DeviceMonitoring.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load monitoring history');
    }
  }

  static Future<List<RelayStatus>> getRelayStatuses(int deviceId) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/relay-status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['relays'];
      return data.map((json) => RelayStatus.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load relay statuses');
    }
  }

  static Future<void> controlRelay({
    required int deviceId,
    required int channel,
    required String command,
  }) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/client/devices/$deviceId/control'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'command': command,
        'channel': channel,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to control relay');
    }
  }



}