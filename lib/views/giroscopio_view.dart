import 'package:flutter/material.dart';
import '../controllers/giroscopio_controller.dart';
import '../models/giroscopio.dart';

class GyroView extends StatefulWidget {
  @override
  _GyroViewState createState() => _GyroViewState();
}

class _GyroViewState extends State<GyroView> {
  final GyroController _controller = GyroController();

  // Colores personalizados
  final Color xAxisColor = Color(0xFFFF6B6B); // Rojo suave
  final Color yAxisColor = Color(0xFF4ECDC4); // Verde azulado
  final Color zAxisColor = Color(0xFF45B7D1); // Azul claro

  @override
  void initState() {
    super.initState();
    _controller.initGyroscope();
    _controller.connectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // Fondo gris muy claro
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.sensors, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              'Control de Giroscopio',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  _controller.isConnected ? Icons.wifi : Icons.wifi_off,
                  color: _controller.isConnected ? Colors.green : Colors.red,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  _controller.isConnected ? 'Conectado' : 'Desconectado',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<GiroscopioData>(
        stream: _controller.gyroDataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando datos...',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGyroCard(
                    'Eje X', snapshot.data!.x, xAxisColor, Icons.swap_horiz),
                SizedBox(height: 16),
                _buildGyroCard(
                    'Eje Y', snapshot.data!.y, yAxisColor, Icons.swap_vert),
                SizedBox(height: 16),
                _buildGyroCard(
                    'Eje Z', snapshot.data!.z, zAxisColor, Icons.rotate_right),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGyroCard(String axis, double value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  axis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color.darker(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Extensión para obtener un color más oscuro
extension ColorExtension on Color {
  Color darker() {
    return Color.fromARGB(
      alpha,
      (red * 0.8).round(),
      (green * 0.8).round(),
      (blue * 0.8).round(),
    );
  }
}
