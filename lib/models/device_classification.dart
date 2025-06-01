import 'package:flutter/material.dart';

class DeviceClassification {
  final String category;
  final double confidence;
  final DateTime updatedAt;

  DeviceClassification({
    required this.category,
    required this.confidence,
    required this.updatedAt,
  });

  factory DeviceClassification.fromJson(Map<String, dynamic> json) {
    return DeviceClassification(
      category: json['category'],
      confidence: double.parse(json['confidence'].toString()),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get formattedCategory {
    switch (category) {
      case 'industrial':
        return 'Industrial Device';
      case 'household':
        return 'Household Device';
      default:
        return category;
    }
  }

  Color get categoryColor {
    switch (category) {
      case 'industrial':
        return Colors.blue;
      case 'household':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case 'industrial':
        return Icons.factory;
      case 'household':
        return Icons.home;
      default:
        return Icons.device_unknown;
    }
  }

  String get formattedConfidence => '${(confidence * 100).toStringAsFixed(1)}%';
}