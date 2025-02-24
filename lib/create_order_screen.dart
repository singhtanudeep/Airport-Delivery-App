import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _storeIDController = TextEditingController();
  final String _orderID = Uuid().v4();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createOrder() async {
    String storeID = _storeIDController.text.trim();

    if (storeID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Store ID is required")),
      );
      return;
    }

    try {
      await _firestore.collection('orders').doc(_orderID).set({
        'storeID': storeID,
        'orderID': _orderID,
        'deliveryStatus': 'Pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order created successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating order: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Order")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _storeIDController,
              decoration: InputDecoration(labelText: "Store ID"),
            ),
            SizedBox(height: 20),
            Text("Generated Order ID: $_orderID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createOrder,
              child: Text("Create Order"),
            ),
          ],
        ),
      ),
    );
  }
}
