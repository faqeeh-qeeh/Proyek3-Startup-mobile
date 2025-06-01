import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/anomaly_service.dart';
import '../../models/client_device.dart';
import '../../models/device_anomaly.dart';
import '../../models/quality_report.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class AnomalyListScreen extends StatefulWidget {
  final ClientDevice device;

  const AnomalyListScreen({Key? key, required this.device}) : super(key: key);

  @override
  _AnomalyListScreenState createState() => _AnomalyListScreenState();
}

class _AnomalyListScreenState extends State<AnomalyListScreen> {
  late Future<List<DeviceAnomaly>> _anomaliesFuture;
  late Future<QualityReport> _qualityFuture;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _anomaliesFuture = AnomalyService.getAnomalies(widget.device.id);
      _qualityFuture = AnomalyService.getRecentQuality(widget.device.id);
    });
  }

  Future<void> _detectAnomalies() async {
    setState(() => _isDetecting = true);
    try {
      final result = await AnomalyService.detectAnomalies(widget.device.id);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terdeteksi ${result['anomalies_count']} anomali'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Deteksi gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isDetecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anomali - ${widget.device.deviceName}'),
        actions: [
          IconButton(
            icon: _isDetecting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.refresh),
            onPressed: _isDetecting ? null : _detectAnomalies,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildQualityCard(),
              _buildAnomaliesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityCard() {
    return FutureBuilder<QualityReport>(
      future: _qualityFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Gagal memuat data kualitas',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final quality = snapshot.data!;
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      color: quality.qualityColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kualitas Listrik',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  quality.qualityMessage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: quality.qualityColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQualityIndicator('Baik', quality.goodPercentage, Colors.green),
                    _buildQualityIndicator('Cukup', quality.fairPercentage, Colors.orange),
                    _buildQualityIndicator('Buruk', quality.poorPercentage, Colors.red),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Terakhir diperbarui: ${DateFormat('dd MMM yyyy HH:mm').format(quality.lastUpdated)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQualityIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAnomaliesList() {
    return FutureBuilder<List<DeviceAnomaly>>(
      future: _anomaliesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat daftar anomali',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Belum ada anomali yang terdeteksi'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final anomaly = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: anomaly.typeColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      anomaly.formattedScore,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: anomaly.typeColor,
                      ),
                    ),
                  ),
                ),
                title: Text(anomaly.typeLabel),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(anomaly.description),
                    const SizedBox(height: 4),
                    Text(
                      anomaly.formattedDate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}