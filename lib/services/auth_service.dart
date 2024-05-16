import 'package:flutter/material.dart';
import 'package:resto/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = 'http://prakashcodes-001-site1.ktempurl.com';

  static Future<User?> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/User'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      // print(response.body.toString());
      if (response.statusCode == 200) {
        var loggedInUser = User.fromJson(json.decode(response.body));
        return loggedInUser;
      }
    } catch (error) {
      print('Error during register: $error');
      throw Exception("Fail to register new user");
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/User/login?email=$email&password=$password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
    } catch (error) {
      print('Error during login: $error');
      throw Exception("Fail to login");
    }
  }

  static Future<User?> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/User/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
    } catch (error) {
      print('Error during login: $error');
      throw Exception("Fail to login");
    }
  }
}
