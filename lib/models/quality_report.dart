import 'package:flutter/material.dart';

class QualityReport {
  final int goodSamples;
  final int fairSamples;
  final int poorSamples;
  final int totalSamples;
  final double qualityScore;
  final String qualityLevel;
  final DateTime lastUpdated;

  QualityReport({
    required this.goodSamples,
    required this.fairSamples,
    required this.poorSamples,
    required this.totalSamples,
    required this.qualityScore,
    required this.qualityLevel,
    required this.lastUpdated,
  });

  factory QualityReport.fromJson(Map<String, dynamic> json) {
    return QualityReport(
      goodSamples: json['good_samples'] ?? 0,
      fairSamples: json['fair_samples'] ?? 0,
      poorSamples: json['poor_samples'] ?? 0,
      totalSamples: json['total_samples'] ?? 1,
      qualityScore: double.parse((json['quality_score'] ?? 0).toString()),
      qualityLevel: json['quality_level'] ?? 'unknown',
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  double get goodPercentage => (goodSamples / totalSamples) * 100;
  double get fairPercentage => (fairSamples / totalSamples) * 100;
  double get poorPercentage => (poorSamples / totalSamples) * 100;

  String get qualityMessage {
    switch (qualityLevel) {
      case 'excellent': return 'Excellent (${qualityScore.toStringAsFixed(0)}%)';
      case 'good': return 'Good (${qualityScore.toStringAsFixed(0)}%)';
      case 'fair': return 'Fair (${qualityScore.toStringAsFixed(0)}%)';
      case 'poor': return 'Poor (${qualityScore.toStringAsFixed(0)}%)';
      default: return 'Unknown';
    }
  }

  Color get qualityColor {
    switch (qualityLevel) {
      case 'excellent': return Colors.green;
      case 'good': return Colors.lightGreen;
      case 'fair': return Colors.orange;
      case 'poor': return Colors.red;
      default: return Colors.grey;
    }
  }
}