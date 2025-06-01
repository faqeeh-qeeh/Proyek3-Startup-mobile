import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/anomaly_service.dart';
import '../../models/client_device.dart';
import '../../models/device_anomaly.dart';
import '../../models/device_classification.dart';
import '../../models/quality_report.dart';

class AnomalyListScreen extends StatefulWidget {
  final ClientDevice device;

  const AnomalyListScreen({Key? key, required this.device}) : super(key: key);

  @override
  _AnomalyListScreenState createState() => _AnomalyListScreenState();
}

class _AnomalyListScreenState extends State<AnomalyListScreen> {
  late Future<Map<String, dynamic>> _anomaliesDataFuture;
  late Future<QualityReport> _qualityFuture;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _anomaliesDataFuture = AnomalyService.getAnomaliesAndClassification(widget.device.id);
      _qualityFuture = AnomalyService.getRecentQuality(widget.device.id);
    });
  }

  Future<void> _detectAnomalies() async {
    setState(() => _isDetecting = true);
    try {
      final result = await AnomalyService.detectAnomalies(widget.device.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terdeteksi ${result['anomalies_count']} anomali'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Update data setelah deteksi
      setState(() {
        _anomaliesDataFuture = Future.value({
          'anomalies': (result['anomalies'] as List<DeviceAnomaly>?) ?? [],
          'classification': result['classification'],
        });
        _qualityFuture = Future.value(QualityReport(
          goodSamples: result['quality_stats']['good'] ?? 0,
          fairSamples: result['quality_stats']['fair'] ?? 0,
          poorSamples: result['quality_stats']['poor'] ?? 0,
          totalSamples: result['quality_stats']['total'] ?? 1,
          qualityScore: result['quality_score'] ?? 0,
          qualityLevel: result['quality_level'] ?? 'unknown',
          lastUpdated: DateTime.now(),
        ));
      });
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Kartu Kualitas Listrik
              _buildQualityCard(),
              const SizedBox(height: 16),
              
              // Kartu Klasifikasi Perangkat
              FutureBuilder<Map<String, dynamic>>(
                future: _anomaliesDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingClassification();
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return _buildErrorClassification();
                  }
                  return _buildClassificationCard(snapshot.data!['classification']);
                },
              ),
              const SizedBox(height: 16),
              
              // Daftar Anomali
              FutureBuilder<Map<String, dynamic>>(
                future: _anomaliesDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Gagal memuat daftar anomali'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Tidak ada data tersedia'));
                  }
                  
                  final anomalies = snapshot.data!['anomalies'] as List<DeviceAnomaly>;
                  return _buildAnomaliesList(anomalies);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder<QualityReport>(
        future: _qualityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Gagal memuat data kualitas'),
            );
          }

          final quality = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      color: quality.qualityColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kualitas Listrik',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getQualityMessage(quality),
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
                    _buildQualityIndicator('Sedang', quality.fairPercentage, Colors.orange),
                    _buildQualityIndicator('Buruk', quality.poorPercentage, Colors.red),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Terakhir diperbarui: ${DateFormat('dd MMM yyyy HH:mm').format(quality.lastUpdated)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getQualityMessage(QualityReport quality) {
    switch (quality.qualityLevel) {
      case 'excellent':
        return 'Kualitas listrik sangat bagus (${quality.qualityScore.toStringAsFixed(0)}%)';
      case 'good':
        return 'Kualitas listrik bagus (${quality.qualityScore.toStringAsFixed(0)}%)';
      case 'fair':
        return 'Kualitas listrik sedang (${quality.qualityScore.toStringAsFixed(0)}%)';
      case 'poor':
        return 'Kualitas listrik buruk (${quality.qualityScore.toStringAsFixed(0)}%)';
      default:
        return 'Kualitas listrik tidak diketahui';
    }
  }

  Widget _buildLoadingClassification() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorClassification() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Gagal memuat klasifikasi perangkat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationCard(DeviceClassification? classification) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.label,
                  color: Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Klasifikasi Perangkat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (classification == null)
              _buildUnclassifiedDevice()
            else
              _buildClassifiedDevice(classification),
          ],
        ),
      ),
    );
  }

  Widget _buildUnclassifiedDevice() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.device_unknown,
          color: Colors.grey,
          size: 28,
        ),
      ),
      title: const Text(
        'Belum Diklasifikasikan',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      subtitle: const Text(
        'Jalankan deteksi anomali untuk mengklasifikasikan perangkat ini',
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildClassifiedDevice(DeviceClassification classification) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: classification.categoryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          classification.categoryIcon,
          color: classification.categoryColor,
          size: 28,
        ),
      ),
      title: Text(
        classification.formattedCategory == 'Industrial Device' 
            ? 'Perangkat Industri' 
            : 'Perangkat Rumah Tangga',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: classification.categoryColor,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: classification.confidence,
            backgroundColor: Colors.grey[200],
            color: classification.categoryColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Keyakinan: ${classification.formattedConfidence}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Diperbarui: ${DateFormat('dd MMM yyyy').format(classification.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAnomaliesList(List<DeviceAnomaly> anomalies) {
    if (anomalies.isEmpty) {
      return Card(
        elevation: 0,
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada anomali yang terdeteksi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Tidak ditemukan masalah pada data monitoring perangkat ini',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Anomali Terdeteksi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ${anomalies.length} anomali',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: anomalies.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final anomaly = anomalies[index];
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: anomaly.typeColor.withOpacity(0.1),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getAnomalyTypeLabel(anomaly.type),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                anomaly.formattedDate,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anomaly.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getAnomalyTypeLabel(String type) {
    switch (type) {
      case 'voltage':
        return 'Anomali Tegangan';
      case 'current':
        return 'Anomali Arus';
      case 'power_factor':
        return 'Anomali Faktor Daya';
      default:
        return 'Anomali Umum';
    }
  }
}