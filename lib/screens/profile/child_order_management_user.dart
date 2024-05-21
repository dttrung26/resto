import 'package:flutter/material.dart';
import 'package:resto/components/buttons/primary_button.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/models/courier.dart';
import 'package:resto/models/order.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/filter/components/price_range.dart';
import 'package:resto/screens/profile/components/shipment_progress_bar.dart';
import 'package:resto/screens/profile/review_screen.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/restaurant_service.dart';

class ChildOrderManagementUser extends StatefulWidget {
  final Order order;
  const ChildOrderManagementUser({super.key, required this.order});

  @override
  State<ChildOrderManagementUser> createState() =>
      _ChildOrderManagementUserState();
}

class _ChildOrderManagementUserState extends State<ChildOrderManagementUser> {
  @override
  void initState() {
    _fetchDistance();
    super.initState();
  }

  Future<double> _fetchDistance() async {
    try {
      User? user = await AuthService.getUserById(widget.order.userID);

      Restaurant? restaurant = await RestaurantService()
          .getRestaurantById(widget.order.restaurantId);

      if (user != null && restaurant != null) {
        return DistanceHelper(restaurant: restaurant, user: user)
            .calculateDistance();
      } else {
        return 11.11;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 11.11;
    }
  }

  final List<Courier> dummyCouriers = [
    const Courier(name: "John Doe", phoneNumber: "123-456-7890"),
    const Courier(name: "Jane Smith", phoneNumber: "987-654-3210"),
    const Courier(name: "Alice Johnson", phoneNumber: "456-789-0123"),
  ];

  Widget build(BuildContext context) {
    String status = OrderHelper(order: widget.order).getOrderStatus();
    int courierIndex = (widget.order.orderId % 3);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<double>(
          future: _fetchDistance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error in getting distance: ${snapshot.error}');
            } else {
              double? distance = snapshot.data ?? 11.11;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Order Information",
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text('Order ID: ${widget.order.orderId}',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('Total Price: \$${widget.order.totalPrice}',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('Restaurant ID: ${widget.order.restaurantId}',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('User ID: ${widget.order.userID}',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('Distance: $distance km',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('Order status: $status',
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
                    height: 15.0,
                  ),
                  (status == "Delivering" || status == "Delivered")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Your Courier Information",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text('Name : ${dummyCouriers[courierIndex].name}',
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text(
                                'Phone: ${dummyCouriers[courierIndex].phoneNumber}',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      : Container(),
                  status == "Delivering"
                      ? ShipmentProgressBar(
                          estimatedDeliveryTimeInMinutes:
                              ((distance / 50) * 60).toInt())
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  status == "Delivering"
                      ? PrimaryButton(
                          text: "I Have Received Order",
                          press: () {
                            RestaurantService().updateDeliveredOrderStatus(
                                true, widget.order.orderId);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(
                                  restaurantId: widget.order.restaurantId,
                                  userId: widget.order.userID,
                                ),
                              ),
                            );
                          })
                      : Container(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
