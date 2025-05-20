import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient _client;
  bool _isConnected = false;

  Future<void> connect(String broker, String clientId) async {
    _client = MqttServerClient(broker, clientId);
    _client.port = 1883;
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.logging(on: false);

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .keepAliveFor(60);
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      rethrow;
    }
  }

  void _onDisconnected() {
    _isConnected = false;
  }

  void publish(String topic, String message) {
    if (!_isConnected) {
      throw Exception('MQTT client not connected');
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void subscribe(String topic, Function(String) callback) {
    if (!_isConnected) {
      throw Exception('MQTT client not connected');
    }
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      callback(message);
    });
  }

  void disconnect() {
    _client.disconnect();
    _isConnected = false;
  }
}