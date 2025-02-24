import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String orderID;
  QRCodeScreen({required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code')),
      body: Center(
        child: QrImageView(
          data: orderID,
          size: 200,
        ),
      ),
    );
  }
}
