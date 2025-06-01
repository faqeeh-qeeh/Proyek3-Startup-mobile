import 'package:flutter/material.dart';
import '../models/device_monitoring.dart';
import '../services/mqtt_service.dart';
import '../models/client_device.dart';
import '../models/device_monitoring.dart';
import 'dart:convert';
class DeviceProvider with ChangeNotifier {
  final MqttService _mqttService;
  ClientDevice? _currentDevice;
  DeviceMonitoring? _latestData;
  Map<int, bool> _relayStatus = {1: false, 2: false, 3: false, 4: false};

  DeviceProvider(this._mqttService);

  ClientDevice? get currentDevice => _currentDevice;
  DeviceMonitoring? get latestData => _latestData;
  Map<int, bool> get relayStatus => _relayStatus;

  void setCurrentDevice(ClientDevice device) {
    _currentDevice = device;
    _subscribeToDeviceUpdates();
    notifyListeners();
  }

  void _subscribeToDeviceUpdates() {
    if (_currentDevice == null) return;
    
    final topic = '${_currentDevice!.mqttTopic}/data';
    _mqttService.subscribe(topic, (message) {
      final data = _parseMonitoringData(message);
      if (data != null) {
        _latestData = data;
        notifyListeners();
      }
    });
  }

  DeviceMonitoring? _parseMonitoringData(String message) {
    try {
      final json = jsonDecode(message);
      return DeviceMonitoring(
        voltage: double.parse(json['voltage'].toString()),
        current: double.parse(json['current'].toString()),
        power: double.parse(json['power'].toString()),
        energy: double.parse(json['energy'].toString()),
        frequency: double.parse(json['frequency'].toString()),
        powerFactor: double.parse(json['power_factor'].toString()),
        recordedAt: DateTime.parse(json['timestamp']),
      );
    } catch (e) {
      return null;
    }
  }

  void updateRelayStatus(int channel, bool status) {
    _relayStatus[channel] = status;
    notifyListeners();
  }
}