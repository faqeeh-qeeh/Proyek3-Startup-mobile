import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/device_service.dart';
import '../../models/client_device.dart';
import '../../providers/auth_provider.dart';
import 'device_detail_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  late Future<List<ClientDevice>> _devicesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    setState(() {
      _devicesFuture = DeviceService.getDevices();
    });
  }

  Future<void> _refreshDevices() async {
    setState(() => _isLoading = true);
    try {
      _loadDevices();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDevices,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<ClientDevice>>(
        future: _devicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load devices'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDevices,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices found'));
          }

          return RefreshIndicator(
            onRefresh: _refreshDevices,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final device = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      Icons.devices_other,
                      color: device.isActive ? Colors.green : Colors.grey,
                    ),
                    title: Text(device.deviceName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (device.latestMonitoringData != null) ...[
                          Text(
                            'Power: ${device.latestMonitoringData!.power.toStringAsFixed(2)} W',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Voltage: ${device.latestMonitoringData!.voltage.toStringAsFixed(2)} V',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                        if (device.description != null)
                          Text(
                            device.description!,
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceDetailScreen(device: device),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}