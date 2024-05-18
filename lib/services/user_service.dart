import 'dart:convert';
import 'package:intl/intl.dart';
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

  Future<bool> updateSubscriptionMethod(
      int userId, bool hasSubscription, int option) async {
    // option = 1 (monthly), option = 12 (annually)
    try {
      DateTime now = DateTime.now();
      DateTime expDate = option == 1
          ? now.add(const Duration(days: 30))
          : now.add(const Duration(days: 365));
      String expFormattedDateTime = DateFormat('yyyy-MM-dd').format(expDate);
      String nowFormattedDateTime = DateFormat('yyyy-MM-dd').format(now);
      print(expFormattedDateTime);
      final response = await http.patch(
        Uri.parse('$apiUrl/api/User?id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode([
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/hasSubscription',
            'value': hasSubscription
          },
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/subscriptionExpirationDate',
            'value':
                hasSubscription ? expFormattedDateTime : nowFormattedDateTime
          }
        ]),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update subscription failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during update subscription: ${error.toString()}');
      throw Exception("Failed to update subscription: ${error.toString()}");
    }
  }
}
