import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

  Future<bool> updateLocation(
      int userId, String address, String postcode) async {
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
            'path': '/address',
            'value': address
          },
          {
            'operationType': 0,
            'op': 'replace',
            'path': '/postcode',
            'value': postcode
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
      throw Exception("Failed to update location ${error.toString()}");
    }
  }
}
