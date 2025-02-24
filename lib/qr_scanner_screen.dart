import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false; // Prevent multiple scans

  void _processQRCode(BarcodeCapture barcode) async {
    if (_isProcessing) return; // Prevent multiple calls
    _isProcessing = true;

    if (barcode.barcodes.isEmpty || barcode.barcodes.first.rawValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid QR Code!")),
      );
      _isProcessing = false;
      return;
    }

    final String scannedData = barcode.barcodes.first.rawValue!;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(scannedData).update({
        'deliveryStatus': 'Delivered',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order marked as Delivered!")),
      );

      Navigator.pop(context, scannedData); // Return scanned data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order: $e")),
      );
    }

    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: _processQRCode, // Process the scanned code
      ),
    );
  }
}
