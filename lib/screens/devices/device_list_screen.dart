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
  late Stream<List<ClientDevice>> _devicesStream;
  List<ClientDevice> _devices = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    _devicesStream = DeviceService.streamDevices();
    _devicesStream.listen(
      (devices) {
        if (mounted) {
          setState(() {
            _devices = devices;
            _isLoading = false;
            _errorMessage = '';
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = error.toString();
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Devices'),
        // Menghapus tombol refresh manual
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _devices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeStream,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_devices.isEmpty) {
      return const Center(child: Text('No devices found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
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
    );
  }
}