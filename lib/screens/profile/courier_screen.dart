import 'package:flutter/material.dart';

class CourierDeliveryScreen extends StatefulWidget {
  const CourierDeliveryScreen({Key? key}) : super(key: key);

  @override
  _CourierDeliveryScreenState createState() => _CourierDeliveryScreenState();
}

class _CourierDeliveryScreenState extends State<CourierDeliveryScreen> {
  // Dummy data for orders
  final List<Map<String, dynamic>> _orders = [
    {'orderId': 1, 'customerName': 'John Doe', 'address': '123 Main St', 'status': 'Pending'},
    {'orderId': 2, 'customerName': 'Jane Smith', 'address': '456 Elm St', 'status': 'Pending'},
    {'orderId': 3, 'customerName': 'Bob Johnson', 'address': '789 Oak St', 'status': 'Pending'},
  ];

  void _acceptOrder(int index) {
    setState(() {
      _orders[index]['status'] = 'Accepted';
    });
  }

  void _denyOrder(int index) {
    setState(() {
      _orders[index]['status'] = 'Denied';
    });
  }

  void _confirmDelivery(int index) {
    setState(() {
      _orders[index]['status'] = 'Delivered';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courier Delivery Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              child: ListTile(
                title: Text('Order ID: ${order['orderId']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer: ${order['customerName']}'),
                    Text('Address: ${order['address']}'),
                    Text('Status: ${order['status']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      onPressed: order['status'] == 'Pending' ? () => _acceptOrder(index) : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: order['status'] == 'Pending' ? () => _denyOrder(index) : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.delivery_dining, color: Colors.blue),
                      onPressed: order['status'] == 'Accepted' ? () => _confirmDelivery(index) : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CourierDeliveryScreen(),
  ));
}
