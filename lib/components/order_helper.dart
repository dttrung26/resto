import 'package:resto/models/order.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';

class OrderHelper {
  final Order order;

  const OrderHelper({required this.order});

  String getOrderStatus() {
    if (order.isDenied) {
      return 'Denied';
    } else if (order.isDelivered) {
      return 'Delivered';
    } else if (order.isReady) {
      return 'Delivering';
    } else if (order.isDone) {
      return 'Done';
    } else if (order.isProcessed) {
      return 'Processed';
    } else {
      return 'Pending';
    }
  }
}

class DistanceHelper {
  final Restaurant restaurant;
  final User user;

  DistanceHelper({required this.restaurant, required this.user});

  double calculateDistance() {
    if (user.postcode != '') {
      return (int.parse(user.postcode!) - int.parse(restaurant.postcode))
              .abs() *
          1.2;
    } else {
      return (2555 - int.parse(restaurant.postcode)).abs() * 1.2;
    }
  }
}
