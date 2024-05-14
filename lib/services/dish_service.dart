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
}
