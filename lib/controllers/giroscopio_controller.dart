import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/giroscopio.dart';

class GyroController {
  final _giroscopioController = StreamController<GiroscopioData>.broadcast();
  WebSocketChannel? channel;
  bool isConnected = false;

  Stream<GiroscopioData> get gyroDataStream => _giroscopioController.stream;

  void initGyroscope() {
    gyroscopeEventStream().listen((event) {
      final data = GiroscopioData(x: event.x, y: event.y, z: event.z);
      _giroscopioController.add(data);
      _processGesture(data);
    });
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.13:8080'));
      isConnected = true;
    } catch (e) {
      print('Conexion Fallida: $e');
    }
  }

  void _processGesture(GiroscopioData data) {
    if (!isConnected) return;

    if (data.x > 3.0) {
      channel?.sink.add('open_browser');
    } else if (data.y > 3.0) {
      channel?.sink.add('open_office');
    } else if (data.z > 3.0) {
      channel?.sink.add('open_media_player');
    }
  }

  void dispose() {
    _giroscopioController.close();
    channel?.sink.close();
  }
}
