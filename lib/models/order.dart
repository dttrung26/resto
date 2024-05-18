import 'dart:convert';
import 'package:resto/models/dish.dart';

class Order {
  final int orderId;
  final bool isProcessed;
  final bool isDone;
  final bool isDenied;
  final bool isReady;
  final bool isDelivered;
  final DateTime dateTime;
  final double totalPrice;
  final int userID;
  final int restaurantId;
  final int? driverId;
  final String? restaurantName;
  final List<Dish>? dishes;

  Order({
    required this.orderId,
    required this.isProcessed,
    required this.isDone,
    required this.isDenied,
    required this.dateTime,
    required this.totalPrice,
    required this.userID,
    required this.restaurantId,
    required this.isReady,
    required this.isDelivered,
    required this.driverId,
    required this.restaurantName,
    required this.dishes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      isProcessed: json['isProcessed'],
      isDone: json['isDone'],
      dateTime: DateTime.parse(json['dateTime']),
      totalPrice: json['totalPrice'],
      userID: json['userID'],
      isDenied: json['isDenied'],
      restaurantId: json['resturantId'],
      isReady: json['isReady'],
      isDelivered: json['isDelivered'],
      driverId: json['driverId'],
      restaurantName: json['resturantName'],
      dishes: json['dishes'] != null
          ? List<Dish>.from(json['dishes'].map((dish) => Dish.fromJson(dish)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'isProcessed': isProcessed,
      'isDone': isDone,
      'dateTime': dateTime.toIso8601String(),
      'totalPrice': totalPrice,
      'userID': userID,
      'resturantId': restaurantId,
      'isReady': isReady,
      'isDelivered': isDelivered,
      'driverId': driverId,
      'isDenied': isDenied,
      'resturantName': restaurantName,
      'dishes': dishes != null
          ? List<dynamic>.from(dishes!.map((dish) => dish.toJson()))
          : null,
    };
  }
}
