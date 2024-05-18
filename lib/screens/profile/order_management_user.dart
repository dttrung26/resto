import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/models/order.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/child_order_management_user.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/order_service.dart';

class OrderManagementUser extends StatefulWidget {
  final User user;
  const OrderManagementUser({super.key, required this.user});

  @override
  State<OrderManagementUser> createState() => _OrderManagementUserState();
}

class _OrderManagementUserState extends State<OrderManagementUser> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService().getOrdersByUserId(widget.user.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management User'),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          } else {
            List<Order> orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                String status = OrderHelper(order: order).getOrderStatus();

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChildOrderManagementUser(order: order),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Text('ID: ${order.orderId}'),
                      title: Text('Total: \$${order.totalPrice}'),
                      subtitle: Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(order.dateTime)}'),
                      trailing: Text('Status: $status'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
