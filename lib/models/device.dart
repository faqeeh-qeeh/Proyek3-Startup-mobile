// class ClientDevice {
//   final int id;
//   final String deviceName;
//   final String mqttTopic;
//   final String status;
//   final String description;
//   final DeviceMonitoring? latestData;

//   ClientDevice({
//     required this.id,
//     required this.deviceName,
//     required this.mqttTopic,
//     required this.status,
//     required this.description,
//     this.latestData,
//   });

//   factory ClientDevice.fromJson(Map<String, dynamic> json) {
//     return ClientDevice(
//       id: json['id'],
//       deviceName: json['device_name'],
//       mqttTopic: json['mqtt_topic'],
//       status: json['status'],
//       description: json['description'],
//       latestData: json['latest_monitoring_data'] != null
//           ? DeviceMonitoring.fromJson(json['latest_monitoring_data'])
//           : null,
//     );
//   }

//   bool get isActive => status == 'active';
// }

// class DeviceMonitoring {
//   final double voltage;
//   final double current;
//   final double power;
//   final double energy;
//   final double frequency;
//   final double powerFactor;
//   final DateTime recordedAt;

//   DeviceMonitoring({
//     required this.voltage,
//     required this.current,
//     required this.power,
//     required this.energy,
//     required this.frequency,
//     required this.powerFactor,
//     required this.recordedAt,
//   });

//   factory DeviceMonitoring.fromJson(Map<String, dynamic> json) {
//     return DeviceMonitoring(
//       voltage: double.parse(json['voltage'].toString()),
//       current: double.parse(json['current'].toString()),
//       power: double.parse(json['power'].toString()),
//       energy: double.parse(json['energy'].toString()),
//       frequency: double.parse(json['frequency'].toString()),
//       powerFactor: double.parse(json['power_factor'].toString()),
//       recordedAt: DateTime.parse(json['recorded_at']),
//     );
//   }
// }