// lib/models/relay_status.dart
class RelayStatus {
  final int channel;
  String status;

  RelayStatus({
    required this.channel,
    required this.status,
  });

  factory RelayStatus.fromJson(Map<String, dynamic> json) {
    return RelayStatus(
      channel: json['channel'],
      status: json['status'],
    );
  }
}