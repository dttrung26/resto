import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resto/models/dish.dart';

class DishService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

  Future<List<Dish>> getDishesForRestaurant(int restaurantId) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/api/Dish/searchByRestaurant?restaurantId=$restaurantId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Dish> dishes = [];
      data.forEach((dishData) {
        dishes.add(Dish.fromJson(dishData));
      });
      return dishes;
    } else {
      print('Failed to load dishes: ${response.statusCode}');
      return [];
    }
  }

  Future<bool> createDishPerRestaurant(Dish dish) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Dish'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dish.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }
}
