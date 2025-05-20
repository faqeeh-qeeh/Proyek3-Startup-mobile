class RelayStatus {
  final int channel;
  final String status;

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

  bool get isOn => status == 'on';
}