import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/models/order.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/order_service.dart';
import 'package:resto/services/restaurant_service.dart';
import 'package:resto/services/user_service.dart';

class OrderManagementRestaurant extends StatefulWidget {
  final Restaurant restaurant;
  const OrderManagementRestaurant({super.key, required this.restaurant});

  @override
  State<OrderManagementRestaurant> createState() =>
      _OrderManagementRestaurantState();
}

class _OrderManagementRestaurantState extends State<OrderManagementRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management Restaurant'),
      ),
      body: FutureBuilder<List<Order>>(
        future: OrderService()
            .getOrdersByRestaurantId(widget.restaurant.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          } else {
            List<Order> pendingOrders = snapshot.data!
                .where((order) =>
                    OrderHelper(order: order).getOrderStatus() == 'Pending')
                .toList();

            if (pendingOrders.isEmpty) {
              return const Center(child: Text('No pending orders found'));
            }

            return ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                Order order = pendingOrders[index];
                String status = OrderHelper(order: order).getOrderStatus();
                return Card(
                  child: ListTile(
                    leading: Text('ID: ${order.orderId}'),
                    title: Text('Total: \$${order.totalPrice}'),
                    subtitle: Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(order.dateTime)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.fastfood),
                          onPressed: () async {
                            RestaurantService()
                                .updateApprovedOrderStatus(true, order.orderId)
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Update order status successfully'),
                                  ),
                                );
                                setState(
                                    () {}); // Refresh the state to update the UI
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Fail to update order status'),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.no_food_rounded),
                          onPressed: () async {
                            RestaurantService()
                                .updateDeniedOrderStatus(true, order.orderId)
                                .then((value) async {
                              if (value) {
                                var normalUser =
                                    await AuthService.getUserById(order.userID);
                                if (normalUser != null) {
                                  double refundAmount =
                                      normalUser.balance + order.totalPrice;
                                  await UserService().updateBalance(
                                      normalUser.userID, refundAmount);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Refund process proceeded successfully!'),
                                    ),
                                  );
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Update order status successfully'),
                                  ),
                                );
                                setState(
                                    () {}); // Refresh the state to update the UI
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Fail to update order status'),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                      ],
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
