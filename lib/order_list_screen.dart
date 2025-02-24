import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';
import 'qr_code_screen.dart';

class OrderListScreen extends StatelessWidget {
  void _scanQRCode(BuildContext context) async {
    final scannedData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );

    if (scannedData != null) {
      await FirebaseFirestore.instance.collection('orders').doc(scannedData).update({
        'deliveryStatus': 'Delivered',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order Marked as Delivered!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders found."));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text("Order ID: ${order['orderID']}"),
                subtitle: Text("Store ID: ${order['storeID']} | Status: ${order['deliveryStatus']}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCodeScreen(orderID: order['orderID']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanQRCode(context),
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
