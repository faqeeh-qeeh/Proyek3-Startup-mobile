// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../api/device_service.dart';
// import '../../models/client_device.dart';
// import '../../providers/auth_provider.dart';
// import 'device_detail_screen.dart';

// class DeviceListScreen extends StatefulWidget {
//   const DeviceListScreen({Key? key}) : super(key: key);

//   @override
//   _DeviceListScreenState createState() => _DeviceListScreenState();
// }

// class _DeviceListScreenState extends State<DeviceListScreen> {
//   late Stream<List<ClientDevice>> _devicesStream;
//   List<ClientDevice> _devices = [];
//   bool _isLoading = true;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeStream();
//   }

//   void _initializeStream() {
//     _devicesStream = DeviceService.streamDevices();
//     _devicesStream.listen(
//       (devices) {
//         if (mounted) {
//           setState(() {
//             _devices = devices;
//             _isLoading = false;
//             _errorMessage = '';
//           });
//         }
//       },
//       onError: (error) {
//         if (mounted) {
//           setState(() {
//             _errorMessage = error.toString();
//             _isLoading = false;
//           });
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Devices'),
//         // Menghapus tombol refresh manual
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading && _devices.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_errorMessage.isNotEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_errorMessage),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _initializeStream,
//               child: const Text('Try Again'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_devices.isEmpty) {
//       return const Center(child: Text('No devices found'));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: _devices.length,
//       itemBuilder: (context, index) {
//         final device = _devices[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           child: ListTile(
//             leading: Icon(
//               Icons.devices_other,
//               color: device.isActive ? Colors.green : Colors.grey,
//             ),
//             title: Text(device.deviceName),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (device.latestMonitoringData != null) ...[
//                   Text(
//                     'Power: ${device.latestMonitoringData!.power.toStringAsFixed(2)} W',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                   Text(
//                     'Voltage: ${device.latestMonitoringData!.voltage.toStringAsFixed(2)} V',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 ],
//                 if (device.description != null)
//                   Text(
//                     device.description!,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//               ],
//             ),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DeviceDetailScreen(device: device),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

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
        title: const Text('Perangkat Saya'),
        backgroundColor: const Color(0xFF041562),
        elevation: 4,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: const Color(0xFF041562),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat daftar perangkat...',
              style: TextStyle(
                color: const Color(0xFF11468F),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: const Color(0xFFDA1212),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat perangkat',
              style: TextStyle(
                color: const Color(0xFF041562),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF041562),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _initializeStream,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other,
              color: const Color(0xFF11468F),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada perangkat ditemukan',
              style: TextStyle(
                color: const Color(0xFF041562),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan perangkat baru untuk memulai',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.separated(
        itemCount: _devices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final device = _devices[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailScreen(device: device),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: device.isActive 
                            ? const Color(0xFF041562).withOpacity(0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.devices_other,
                        color: device.isActive 
                            ? const Color(0xFF041562)
                            : Colors.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.deviceName,
                            style: TextStyle(
                              color: const Color(0xFF041562),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (device.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              device.description!,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                          if (device.latestMonitoringData != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatusChip(
                                  '${device.latestMonitoringData!.power.toStringAsFixed(2)} W',
                                  Icons.bolt,
                                ),
                                const SizedBox(width: 8),
                                _buildStatusChip(
                                  '${device.latestMonitoringData!.voltage.toStringAsFixed(2)} V',
                                  Icons.flash_on,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: const Color(0xFF11468F),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF11468F),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF041562),
            ),
          ),
        ],
      ),
    );
  }
}