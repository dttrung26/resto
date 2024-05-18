import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resto/models/order.dart';

class OrderService {
  final String baseUrl = 'http://prakashcodes-001-site1.ktempurl.com/api/Order';

  Future<Order> getOrderById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<Order?> postOrder(Order order) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      print('Fail to post order with ${response.statusCode}');
      return null;
    } else {
      print(response.body);
      var order = Order.fromJson(json.decode(response.body));
      return order;
    }
  }
}
