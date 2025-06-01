import 'package:intl/intl.dart';
import 'device_monitoring.dart';
import 'package:flutter/material.dart';

class DeviceAnomaly {
  final int id;
  final int deviceId;
  final int monitoringId;
  final double score;
  final String type;
  final String description;
  final DateTime createdAt;
  final DeviceMonitoring? monitoringData;

  DeviceAnomaly({
    required this.id,
    required this.deviceId,
    required this.monitoringId,
    required this.score,
    required this.type,
    required this.description,
    required this.createdAt,
    this.monitoringData,
  });

  factory DeviceAnomaly.fromJson(Map<String, dynamic> json) {
    return DeviceAnomaly(
      id: json['id'],
      deviceId: json['device_id'],
      monitoringId: json['monitoring_id'],
      score: double.parse(json['score'].toString()),
      type: json['type'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      monitoringData: json['monitoring'] != null 
          ? DeviceMonitoring.fromJson(json['monitoring'])
          : null,
    );
  }

  String get formattedScore => score.toStringAsFixed(2);
  String get formattedDate => DateFormat('dd MMM yyyy HH:mm').format(createdAt);

  String get typeLabel {
    switch (type) {
      case 'voltage': return 'Voltage Anomaly';
      case 'current': return 'Current Anomaly';
      case 'power_factor': return 'Power Factor Anomaly';
      default: return 'General Anomaly';
    }
  }

  Color get typeColor {
    switch (type) {
      case 'voltage': return Colors.orange;
      case 'current': return Colors.red;
      case 'power_factor': return Colors.blue;
      default: return Colors.grey;
    }
  }
}