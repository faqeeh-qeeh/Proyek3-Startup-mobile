import 'device_monitoring.dart';
import 'relay_status.dart';
import 'product.dart';
import 'order.dart';
class ClientDevice {
  final int id;
  final int clientId;
  final int orderId;
  final int productId;
  final String mqttTopic;
  final String deviceName;
  final String status;
  final String? description;
  final Product? product;
  final Order? order;
  final DeviceMonitoring? latestMonitoringData;

  ClientDevice({
    required this.id,
    required this.clientId,
    required this.orderId,
    required this.productId,
    required this.mqttTopic,
    required this.deviceName,
    required this.status,
    this.description,
    this.product,
    this.order,
    this.latestMonitoringData,
  });

  factory ClientDevice.fromJson(Map<String, dynamic> json) {
    return ClientDevice(
      id: json['id'],
      clientId: json['client_id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      mqttTopic: json['mqtt_topic'],
      deviceName: json['device_name'],
      status: json['status'],
      description: json['description'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
      latestMonitoringData: json['latest_monitoring_data'] != null 
          ? DeviceMonitoring.fromJson(json['latest_monitoring_data'])
          : null,
    );
  }

  bool get isActive => status == 'active';
}