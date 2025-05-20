class DeviceMonitoring {
  final int id;
  final int deviceId;
  final double voltage;
  final double current;
  final double power;
  final double energy;
  final double frequency;
  final double powerFactor;
  final DateTime recordedAt;

  DeviceMonitoring({
    required this.id,
    required this.deviceId,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
    required this.frequency,
    required this.powerFactor,
    required this.recordedAt,
  });

  factory DeviceMonitoring.fromJson(Map<String, dynamic> json) {
    return DeviceMonitoring(
      id: json['id'],
      deviceId: json['device_id'],
      voltage: json['voltage'] is String 
          ? double.parse(json['voltage'])
          : json['voltage'].toDouble(),
      current: json['current'] is String
          ? double.parse(json['current'])
          : json['current'].toDouble(),
      power: json['power'] is String
          ? double.parse(json['power'])
          : json['power'].toDouble(),
      energy: json['energy'] is String
          ? double.parse(json['energy'])
          : json['energy'].toDouble(),
      frequency: json['frequency'] is String
          ? double.parse(json['frequency'])
          : json['frequency'].toDouble(),
      powerFactor: json['power_factor'] is String
          ? double.parse(json['power_factor'])
          : json['power_factor'].toDouble(),
      recordedAt: DateTime.parse(json['recorded_at']),
    );
  }

  String get formattedVoltage => '${voltage.toStringAsFixed(2)} V';
  String get formattedCurrent => '${current.toStringAsFixed(2)} A';
  String get formattedPower => '${power.toStringAsFixed(2)} W';
  String get formattedEnergy => '${energy.toStringAsFixed(2)} kWh';
  String get formattedFrequency => '${frequency.toStringAsFixed(2)} Hz';
  String get formattedPowerFactor => powerFactor.toStringAsFixed(2);
}