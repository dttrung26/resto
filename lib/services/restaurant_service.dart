import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resto/models/restaurant.dart';

class RestaurantService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

  Future<bool> createRestaurant(Restaurant resto) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Resturant'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(resto.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<List<Restaurant>>? getRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Resturant'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<Restaurant> restaurants =
            data.map((json) => Restaurant.fromJson(json)).toList();

        return restaurants;
      } else {
        print('Failed to load restaurants: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred while fetching restaurants: $e');
      return [];
    }
  }

  Future<Restaurant?> getRestaurantByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Resturant/searchByuserId?userId=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data.toString());
        if (data.isNotEmpty) {
          return Restaurant.fromJson(data.first);
        } else {
          return null;
        }
      } else {
        print('Failed to load restaurants: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred while fetching restaurants: $e');
      return null;
    }
  }

  Future<Restaurant?> getRestaurantById(int restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/Resturant/$restaurantId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data.toString());
        if (data.isNotEmpty) {
          return Restaurant.fromJson(data.first);
        } else {
          return null;
        }
      } else {
        print('Failed to load restaurant: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred while fetching restaurant: $e');
      return null;
    }
  }

  Future<List<Restaurant>> searchRestaurants(String keywords) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/Resturant/search?keywords=$keywords'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Restaurant> restaurants = [];
      data.forEach((restaurantData) {
        restaurants.add(Restaurant.fromJson(restaurantData));
      });
      return restaurants;
    } else {
      return [];
    }
  }

  Future<bool> updateDeniedOrderStatus(bool isDenied, int orderId) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/Order?id=$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/isDenied',
            'value': isDenied
          }
        ]),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during order status: ${error.toString()}');
      throw Exception("Failed to update order status: ${error.toString()}");
    }
  }

  Future<bool> updateApprovedOrderStatus(bool isReady, int orderId) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/Order?id=$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/isReady',
            'value': isReady
          }
        ]),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during order status: ${error.toString()}');
      throw Exception("Failed to update order status: ${error.toString()}");
    }
  }

  Future<bool> updateDeliveredOrderStatus(bool isDelivered, int orderId) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/Order?id=$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/isDelivered',
            'value': isDelivered
          }
        ]),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during order status: ${error.toString()}');
      throw Exception("Failed to update order status: ${error.toString()}");
    }
  }
}
