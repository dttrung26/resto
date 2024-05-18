import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/models/order.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/screens/profile/child_order_management_user.dart';
import 'package:resto/services/order_service.dart';
import 'package:resto/services/restaurant_service.dart';

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
                          icon: Icon(Icons.fastfood),
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
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fail to order status'),
                                  ),
                                );
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.no_food_rounded),
                          onPressed: () async {
                            RestaurantService()
                                .updateDeniedOrderStatus(true, order.orderId)
                                .then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Update order status successfully'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fail to order status'),
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
