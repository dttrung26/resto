import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/order.dart';
import 'package:resto/services/restaurant_service.dart';

class RevenueScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RevenueScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  List<Order> _orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Start Date and Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => _selectStartDateTime(context),
              child: Text(
                _startDateTime != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_startDateTime!)
                    : 'Select Date and Time',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select End Date and Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => _selectEndDateTime(context),
              child: Text(
                _endDateTime != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_endDateTime!)
                    : 'Select Date and Time',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchOrdersByDuration();
              },
              child: Text('Fetch Orders'),
            ),
            SizedBox(height: 20),
            Text(
              _orders.isNotEmpty
                  ? 'Total revenue from ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_startDateTime!)} to ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_endDateTime!)} is \$${_calculateTotalRevenue().toStringAsFixed(2)}'
                  : '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID: ${_orders[index].orderId}'),
                    subtitle: Text(
                        'Total Price: \$${_orders[index].totalPrice.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timePicked != null) {
        setState(() {
          _startDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timePicked != null) {
        setState(() {
          _endDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  Future<void> _fetchOrdersByDuration() async {
    try {
      List<Order> orders = await RestaurantService().getOrdersByDuration(
        _startDateTime!.toString(),
        _endDateTime!.toString(),
        widget.restaurant.restaurantId,
      );
      // Filter orders that are delivered
      orders = orders.where((order) => order.isDelivered).toList();
      setState(() {
        _orders = orders;
      });
    } catch (error) {
      print('Error fetching orders: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch orders: $error'),
        ),
      );
    }
  }

  double _calculateTotalRevenue() {
    double totalRevenue = 0;
    for (Order order in _orders) {
      totalRevenue += order.totalPrice;
    }
    return totalRevenue;
  }
}
