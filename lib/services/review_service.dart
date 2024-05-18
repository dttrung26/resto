import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resto/models/review.dart';

class ReviewService {
  static const String baseUrl =
      'http://prakashcodes-001-site1.ktempurl.com/api/Review';

  Future<void> postReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(review.toJson()),
      );
      print(review.toJson());
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Review posted successfully');
      } else {
        throw Exception('Failed to post review');
      }
    } catch (e) {
      throw Exception('Failed to post review: $e');
    }
  }

  Future<List<Review>> getReviewByRestaurant(int restaurantId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$restaurantId'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((review) => Review.fromJson(review)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }
}
