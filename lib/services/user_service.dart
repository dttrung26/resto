import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

//PATCH format
// [
//   {
//     "op": "replace",
//     "path": "/address",
//     "value": "Kiama"
//   }
// ]

  Future<bool> updatePaymentMethod(int userId, String cardNumber) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/User?id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/cardNumber',
            'value': cardNumber
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
      print('Error during update card: ${error.toString()}');
      throw Exception("Failed to update card: ${error.toString()}");
    }
  }

  Future<bool> updateBalance(int userId, double balance) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/User?id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/balance',
            'value': balance
          }
        ]),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update balance failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during update balance: ${error.toString()}');
      throw Exception("Failed to update balance: ${error.toString()}");
    }
  }
}
