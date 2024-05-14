import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resto/models/restaurant.dart';

class RestaurantService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

  Future<bool> createRestaurant(Restaurant resto) async {
    try {
      print(resto.toJson());
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
        print(data.toString());
        final List<Restaurant> restaurants =
            data.map((json) => Restaurant.fromJson(json)).toList();
        print("restaurant_service.dart ${restaurants.toString()}");
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
}
