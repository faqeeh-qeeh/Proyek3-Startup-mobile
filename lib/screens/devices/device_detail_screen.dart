import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/client_device.dart';
import '../../models/device_monitoring.dart';
class DeviceDetailScreen extends StatefulWidget {
  final ClientDevice device;

  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.deviceName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.device.latestMonitoringData != null) ...[
              _buildMonitoringCard(widget.device.latestMonitoringData!),
              const SizedBox(height: 16),
              _buildPowerChart(),
            ],
            _buildDeviceInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(DeviceMonitoring data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Monitoring Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('Voltage', '${data.voltage.toStringAsFixed(2)} V'),
                _buildTableRow('Current', '${data.current.toStringAsFixed(2)} A'),
                _buildTableRow('Power', '${data.power.toStringAsFixed(2)} W'),
                _buildTableRow('Energy', '${data.energy.toStringAsFixed(2)} kWh'),
                _buildTableRow('Frequency', '${data.frequency.toStringAsFixed(2)} Hz'),
                _buildTableRow('Power Factor', data.powerFactor.toStringAsFixed(2)),
                _buildTableRow('Last Update', 
                    '${data.recordedAt.toLocal().toString().substring(0, 16)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildPowerChart() {
    // Ini contoh - dalam implementasi nyata bisa ambil dari history monitoring
    final List<Map<String, dynamic>> dummyData = [
      {'time': '10:00', 'power': widget.device.latestMonitoringData!.power - 10},
      {'time': '10:05', 'power': widget.device.latestMonitoringData!.power - 5},
      {'time': '10:10', 'power': widget.device.latestMonitoringData!.power},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Power Consumption',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(title: AxisTitle(text: 'Power (W)')),
                series: <LineSeries<Map<String, dynamic>, String>>[
                  LineSeries<Map<String, dynamic>, String>(
                    dataSource: dummyData,
                    xValueMapper: (data, _) => data['time'],
                    yValueMapper: (data, _) => data['power'],
                    name: 'Power',
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('Device Name', widget.device.deviceName),
                _buildTableRow('Status', widget.device.status),
                _buildTableRow('MQTT Topic', widget.device.mqttTopic),
                if (widget.device.product != null)
                  _buildTableRow('Product', widget.device.product!.name),
                if (widget.device.order != null)
                  _buildTableRow('Order', widget.device.order!.orderNumber),
              ],
            ),
          ],
        ),
      ),
    );
  }
}