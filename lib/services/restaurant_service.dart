import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resto/models/restaurant.dart';

class RestaurantService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

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
}
