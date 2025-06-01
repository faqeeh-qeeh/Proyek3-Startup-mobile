// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../api/device_service.dart';
// import '../../models/client_device.dart';
// import '../../models/device_monitoring.dart';
// import '../../models/relay_status.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';
// import 'anomaly_list_screen.dart';

// class DeviceDetailScreen extends StatefulWidget {
//   final ClientDevice device;

//   const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

//   @override
//   _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
// }

// class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
//   late Stream<DeviceMonitoring> _monitoringStream;
//   late StreamSubscription<DeviceMonitoring> _monitoringSubscription;
//   DeviceMonitoring? _latestData;
//   List<DeviceMonitoring> _monitoringHistory = [];
//   List<RelayStatus> _relayStatuses = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeStreams();
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     _monitoringSubscription.cancel();
//     super.dispose();
//   }

//   void _initializeStreams() {
//     _monitoringStream = DeviceService.streamLatestMonitoringData(
//       widget.device.id,
//     );
//     _monitoringSubscription = _monitoringStream.listen(
//       (data) {
//         setState(() {
//           _latestData = data;
//           _isLoading = false;
//           _hasError = false;
//           _monitoringHistory.insert(0, data);
//           if (_monitoringHistory.length > 10) {
//             _monitoringHistory.removeLast();
//           }
//         });
//       },
//       onError: (error) {
//         setState(() {
//           _hasError = true;
//           _errorMessage = error.toString();
//           _isLoading = false;
//         });
//         Fluttertoast.showToast(
//           msg: "Gagal memperbarui data: $error",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );
//       },
//     );
//   }

//   Future<void> _loadInitialData() async {
//     try {
//       final initialData = await DeviceService.getLatestMonitoringData(
//         widget.device.id,
//       );
//       final history = await DeviceService.getMonitoringHistory(
//         widget.device.id,
//       );
//       final relays = await DeviceService.getRelayStatuses(widget.device.id);

//       setState(() {
//         _latestData = initialData;
//         _monitoringHistory = history.take(10).toList();
//         _relayStatuses = relays;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _refreshData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await _loadInitialData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.deviceName),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _refreshData,
//           ),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading && _latestData == null) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text(
//               'Memuat data perangkat...',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, color: Colors.red, size: 48),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Text(
//                 _errorMessage,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.refresh),
//               label: const Text('Coba Lagi'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               onPressed: _refreshData,
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_latestData != null) ...[
//               _buildMonitoringCard(_latestData!),
//               _buildPowerChart(),
//             ],
//             _buildRelayControls(),
//             _buildDeviceInfo(),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
// Widget _buildMonitoringCard(DeviceMonitoring data) {
//   return Container(
//     margin: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Theme.of(context).colorScheme.surface,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.monitor_heart,
//                 color: Theme.of(context).primaryColor,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Data Monitoring Terkini',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             childAspectRatio: 1.8,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 0,
//             children: [
//               _buildMetricCard(
//                 'Tegangan',
//                 data.formattedVoltage,
//                 Icons.bolt,
//                 Colors.blue,
//               ),
//               _buildMetricCard(
//                 'Arus',
//                 data.formattedCurrent,
//                 Icons.electric_bolt,
//                 Colors.green,
//               ),
//               _buildMetricCard(
//                 'Daya',
//                 data.formattedPower,
//                 Icons.power,
//                 Colors.red,
//               ),
//               _buildMetricCard(
//                 'Energi',
//                 data.formattedEnergy,
//                 Icons.energy_savings_leaf,
//                 Colors.teal,
//               ),
//               _buildMetricCard(
//                 'Frekuensi',
//                 data.formattedFrequency,
//                 Icons.waves,
//                 Colors.orange,
//               ),
//               _buildMetricCard(
//                 'Faktor Daya',
//                 data.formattedPowerFactor,
//                 Icons.trending_up,
//                 Colors.purple,
//               ),
//             ],
//           ),
//           const SizedBox(height: 0),
//           ListTile(
//             contentPadding: EdgeInsets.zero, // Padding diatur nol
//             minLeadingWidth: 24, // Lebar leading icon dikurangi
//             leading: const Icon(Icons.warning_amber, color: Colors.orange, size: 24),
//             title: const Text(
//               'Cek Anomali',
//               style: TextStyle(fontSize: 16), // Ukuran teks diperbesar
//             ),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AnomalyListScreen(device: widget.device),
//                 ),
//               );
//             },
//           ),
//           Divider(color: Colors.grey.shade300),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
//               const SizedBox(width: 8),
//               Text(
//                 'Terakhir diperbarui: ${data.recordedAt.toLocal().toString().substring(0, 16)}',
//                 style: TextStyle(
//                   color: Colors.grey.shade600, 
//                   fontSize: 12
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _buildMetricCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: Theme.of(context).colorScheme.background,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 20, color: color),
//                 const SizedBox(width: 4),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 0),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricTile(String title, String value, IconData icon) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.background,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Theme.of(context).primaryColor),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPowerChart() {
//     // Ambil hanya 10 data terakhir
//     final chartData = _monitoringHistory.take(10).toList().reversed.toList();

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.show_chart, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Monitor Daya',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 250,
//               child: SfCartesianChart(
//                 plotAreaBorderWidth: 0,
//                 primaryXAxis: CategoryAxis(
//                   labelRotation: -45,
//                   labelStyle: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 10,
//                   ),
//                   axisLine: const AxisLine(width: 0),
//                   majorGridLines: const MajorGridLines(width: 0),
//                   majorTickLines: const MajorTickLines(size: 0),
//                 ),
//                 primaryYAxis: NumericAxis(
//                   title: AxisTitle(text: 'Power (W)'),
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   axisLine: const AxisLine(width: 0),
//                   majorTickLines: const MajorTickLines(size: 0),
//                   majorGridLines: MajorGridLines(color: Colors.grey.shade200),
//                   minimum: 0,
//                   maximum:
//                       chartData.isNotEmpty
//                           ? (chartData.map((e) => e.power).reduce(max) * 1.2)
//                           : 120,
//                 ),
//                 series: <LineSeries<DeviceMonitoring, String>>[
//                   LineSeries<DeviceMonitoring, String>(
//                     dataSource: chartData,
//                     xValueMapper:
//                         (data, _) =>
//                             '${data.recordedAt.toLocal().minute.toString().padLeft(2, '0')}:${data.recordedAt.toLocal().second.toString().padLeft(2, '0')}',
//                     yValueMapper: (data, _) => data.power,
//                     name: 'Power',
//                     color: Theme.of(context).primaryColor,
//                     width: 2.5,
//                     markerSettings: const MarkerSettings(
//                       isVisible: true,
//                       shape: DataMarkerType.circle,
//                       borderWidth: 2,
//                       borderColor: Colors.white,
//                       color: Colors.blue,
//                       height: 6,
//                       width: 6,
//                     ),
//                   ),
//                 ],
//                 tooltipBehavior: TooltipBehavior(
//                   enable: true,
//                   format: 'Power: point.y W',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRelayControls() {
//     if (_relayStatuses.isEmpty) return const SizedBox();

//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.power_settings_new,
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Kontrol Relay',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ..._relayStatuses.map((relay) => _buildRelaySwitch(relay)).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRelaySwitch(RelayStatus relay) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.background,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: SwitchListTile(
//         title: Text(
//           'Relay ${relay.channel}',
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//         secondary: Icon(
//           relay.status == 'on' ? Icons.power : Icons.power_off,
//           color: relay.status == 'on' ? Colors.green : Colors.grey,
//         ),
//         value: relay.status == 'on',
//         onChanged: (value) async {
//           try {
//             await DeviceService.controlRelay(
//               deviceId: widget.device.id,
//               channel: relay.channel,
//               command: value ? 'on' : 'off',
//             );
//             setState(() {
//               relay.status = value ? 'on' : 'off';
//             });
//           } catch (e) {
//             Fluttertoast.showToast(
//               msg: "Gagal mengontrol relay: $e",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//             );
//           }
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildDeviceInfo() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Informasi Perangkat',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _getDeviceInfoItems().length,
//               separatorBuilder:
//                   (context, index) =>
//                       Divider(color: Colors.grey.shade300, height: 24),
//               itemBuilder: (context, index) {
//                 final item = _getDeviceInfoItems()[index];
//                 return _buildInfoRow(item['label']!, item['value']!);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Map<String, String>> _getDeviceInfoItems() {
//     return [
//       {'label': 'Nama Perangkat', 'value': widget.device.deviceName},
//       {'label': 'Status', 'value': widget.device.status},
//       {'label': 'Topik MQTT', 'value': widget.device.mqttTopic},
//       if (widget.device.product != null)
//         {'label': 'Produk', 'value': widget.device.product!.name},
//       if (widget.device.order != null)
//         {'label': 'Nomor Order', 'value': widget.device.order!.orderNumber},
//     ];
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../api/device_service.dart';
import '../../models/client_device.dart';
import '../../models/device_monitoring.dart';
import '../../models/relay_status.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'anomaly_list_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  final ClientDevice device;

  const DeviceDetailScreen({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late Stream<DeviceMonitoring> _monitoringStream;
  late StreamSubscription<DeviceMonitoring> _monitoringSubscription;
  DeviceMonitoring? _latestData;
  List<DeviceMonitoring> _monitoringHistory = [];
  List<RelayStatus> _relayStatuses = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeStreams();
    _loadInitialData();
  }

  @override
  void dispose() {
    _monitoringSubscription.cancel();
    super.dispose();
  }

  void _initializeStreams() {
    _monitoringStream = DeviceService.streamLatestMonitoringData(
      widget.device.id,
    );
    _monitoringSubscription = _monitoringStream.listen(
      (data) {
        setState(() {
          _latestData = data;
          _isLoading = false;
          _hasError = false;
          _monitoringHistory.insert(0, data);
          if (_monitoringHistory.length > 10) {
            _monitoringHistory.removeLast();
          }
        });
      },
      onError: (error) {
        setState(() {
          _hasError = true;
          _errorMessage = error.toString();
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Gagal memperbarui data: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xFFDA1212),
          textColor: Colors.white,
        );
      },
    );
  }

  Future<void> _loadInitialData() async {
    try {
      final initialData = await DeviceService.getLatestMonitoringData(
        widget.device.id,
      );
      final history = await DeviceService.getMonitoringHistory(
        widget.device.id,
      );
      final relays = await DeviceService.getRelayStatuses(widget.device.id);

      setState(() {
        _latestData = initialData;
        _monitoringHistory = history.take(10).toList();
        _relayStatuses = relays;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.deviceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF041562),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEEEEEE),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _latestData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: const Color(0xFF041562),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat data perangkat...',
              style: TextStyle(
                color: const Color(0xFF11468F),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
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
              'Terjadi Kesalahan',
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
                style: TextStyle(
                  color: const Color(0xFF11468F),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF041562),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF041562),
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_latestData != null) ...[
              _buildMonitoringCard(_latestData!),
              const SizedBox(height: 8),
              _buildPowerChart(),
            ],
            const SizedBox(height: 8),
            _buildRelayControls(),
            const SizedBox(height: 8),
            _buildDeviceInfo(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(DeviceMonitoring data) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.monitor_heart,
                  color: const Color(0xFF041562),
                ),
                const SizedBox(width: 8),
                Text(
                  'Data Monitoring Terkini',
                  style: TextStyle(
                    color: const Color(0xFF041562),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMetricCard(
                  'Tegangan',
                  data.formattedVoltage,
                  Icons.bolt,
                  const Color(0xFF11468F),
                ),
                _buildMetricCard(
                  'Arus',
                  data.formattedCurrent,
                  Icons.electric_bolt,
                  const Color(0xFF041562),
                ),
                _buildMetricCard(
                  'Daya',
                  data.formattedPower,
                  Icons.power,
                  const Color(0xFF041562),
                ),
                _buildMetricCard(
                  'Energi',
                  data.formattedEnergy,
                  Icons.energy_savings_leaf,
                  const Color(0xFF11468F),
                ),
                _buildMetricCard(
                  'Frekuensi',
                  data.formattedFrequency,
                  Icons.waves,
                  const Color(0xFF041562),
                ),
                _buildMetricCard(
                  'Faktor Daya',
                  data.formattedPowerFactor,
                  Icons.trending_up,
                  const Color(0xFF11468F),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnomalyListScreen(device: widget.device),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: const Color(0xFFDA1212),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Cek Anomali',
                      style: TextStyle(
                        color: const Color(0xFF041562),
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right,
                      color: const Color(0xFF11468F),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Terakhir diperbarui: ${DateFormat('dd MMM yyyy, HH:mm:ss').format(data.recordedAt.toLocal())}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPowerChart() {
  //   final chartData = _monitoringHistory.take(10).toList().reversed.toList();

  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.show_chart,
  //                 color: const Color(0xFF041562),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Monitor Daya',
  //                 style: TextStyle(
  //                   color: const Color(0xFF041562),
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           SizedBox(
  //             height: 250,
  //             child: SfCartesianChart(
  //               plotAreaBorderWidth: 0,
  //               primaryXAxis: CategoryAxis(
  //                 labelRotation: -45,
  //                 labelStyle: TextStyle(
  //                   color: Colors.grey.shade600,
  //                   fontSize: 10,
  //                 ),
  //                 axisLine: const AxisLine(width: 0),
  //                 majorGridLines: const MajorGridLines(width: 0),
  //                 majorTickLines: const MajorTickLines(size: 0),
  //               ),
  //               primaryYAxis: NumericAxis(
  //                 title: AxisTitle(text: 'Daya (W)'),
  //                 labelStyle: TextStyle(color: Colors.grey.shade600),
  //                 axisLine: const AxisLine(width: 0),
  //                 majorTickLines: const MajorTickLines(size: 0),
  //                 majorGridLines: MajorGridLines(color: Colors.grey.shade200),
  //                 minimum: 0,
  //                 maximum: chartData.isNotEmpty
  //                     ? (chartData.map((e) => e.power).reduce(max) * 1.2)
  //                     : 120,
  //               ),
  //               series: <LineSeries<DeviceMonitoring, String>>[
  //                 LineSeries<DeviceMonitoring, String>(
  //                   dataSource: chartData,
  //                   xValueMapper: (data, _) =>
  //                       '${data.recordedAt.toLocal().hour.toString().padLeft(2, '0')}:${data.recordedAt.toLocal().minute.toString().padLeft(2, '0')}',
  //                   yValueMapper: (data, _) => data.power,
  //                   name: 'Daya',
  //                   color: const Color(0xFF041562),
  //                   width: 2.5,
  //                   markerSettings: const MarkerSettings(
  //                     isVisible: true,
  //                     shape: DataMarkerType.circle,
  //                     borderWidth: 2,
  //                     borderColor: Colors.white,
  //                     height: 6,
  //                     width: 6,
  //                   ),
  //                 ),
  //               ],
  //               tooltipBehavior: TooltipBehavior(
  //                 enable: true,
  //                 format: 'Daya: point.y W',
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPowerChart() {
    // Ambil hanya 10 data terakhir
    final chartData = _monitoringHistory.take(10).toList().reversed.toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Monitor Daya',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelRotation: -45,
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Power (W)'),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(color: Colors.grey.shade200),
                  minimum: 0,
                  maximum:
                      chartData.isNotEmpty
                          ? (chartData.map((e) => e.power).reduce(max) * 1.2)
                          : 120,
                ),
                series: <LineSeries<DeviceMonitoring, String>>[
                  LineSeries<DeviceMonitoring, String>(
                    dataSource: chartData,
                    xValueMapper:
                        (data, _) =>
                            '${data.recordedAt.toLocal().minute.toString().padLeft(2, '0')}:${data.recordedAt.toLocal().second.toString().padLeft(2, '0')}',
                    yValueMapper: (data, _) => data.power,
                    name: 'Power',
                    color: Theme.of(context).primaryColor,
                    width: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      shape: DataMarkerType.circle,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      color: Colors.blue,
                      height: 6,
                      width: 6,
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'Power: point.y W',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelayControls() {
    if (_relayStatuses.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.power_settings_new,
                  color: const Color(0xFF041562),
                ),
                const SizedBox(width: 8),
                Text(
                  'Kontrol Relay',
                  style: TextStyle(
                    color: const Color(0xFF041562),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._relayStatuses.map((relay) => _buildRelaySwitch(relay)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaySwitch(RelayStatus relay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          'Relay ${relay.channel}',
          style: TextStyle(
            color: const Color(0xFF041562),
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: Icon(
          relay.status == 'on' ? Icons.power : Icons.power_off,
          color: relay.status == 'on' ? const Color(0xFFDA1212) : Colors.grey,
        ),
        value: relay.status == 'on',
        onChanged: (value) async {
          try {
            await DeviceService.controlRelay(
              deviceId: widget.device.id,
              channel: relay.channel,
              command: value ? 'on' : 'off',
            );
            setState(() {
              relay.status = value ? 'on' : 'off';
            });
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Gagal mengontrol relay: $e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xFFDA1212),
              textColor: Colors.white,
            );
          }
        },
        activeColor: const Color(0xFF041562),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF041562),
                ),
                const SizedBox(width: 8),
                Text(
                  'Informasi Perangkat',
                  style: TextStyle(
                    color: const Color(0xFF041562),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getDeviceInfoItems().length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade200,
                height: 24,
              ),
              itemBuilder: (context, index) {
                final item = _getDeviceInfoItems()[index];
                return _buildInfoRow(item['label']!, item['value']!);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getDeviceInfoItems() {
    return [
      {'label': 'Nama Perangkat', 'value': widget.device.deviceName},
      {'label': 'Status', 'value': widget.device.status},
      {'label': 'Topik MQTT', 'value': widget.device.mqttTopic},
      if (widget.device.product != null)
        {'label': 'Produk', 'value': widget.device.product!.name},
      if (widget.device.order != null)
        {'label': 'Nomor Order', 'value': widget.device.order!.orderNumber},
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: const Color(0xFF041562),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}