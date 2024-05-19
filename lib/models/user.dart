import 'dart:convert';

class User {
  int userID;
  String username;
  String password;
  String email;
  String? phoneNumber;
  String role;
  double balance;
  String? address;
  String? postcode;
  String? cardNumber;
  bool? hasSubscription;
  String? subscreatedAt;
  String? subscriptionExpirationDate;
  List<String>? reviews;
  List<String>? orders;

  User({
    required this.userID,
    required this.username,
    required this.password,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.balance = 0,
    this.address,
    this.postcode,
    this.cardNumber = '',
    this.hasSubscription = false,
    this.subscreatedAt,
    this.subscriptionExpirationDate,
    this.reviews,
    this.orders,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userID: json['userID'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        role: json['role'],
        balance: json['balance'],
        address: json['address'],
        postcode: json['postcode'],
        cardNumber: json['cardNumber'],
        hasSubscription: json['hasSubscription'],
        subscreatedAt: json['subscreatedat'],
        subscriptionExpirationDate: json['subscriptionExpirationDate'],
        reviews:
            json['reviews'] != null ? List<String>.from(json['reviews']) : null,
        orders:
            json['orders'] != null ? List<String>.from(json['orders']) : null,
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'username': username,
        'password': password,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'balance': balance,
        'address': address,
        'postcode': postcode,
        'cardNumber': cardNumber,
        'hasSubscription': hasSubscription,
        'subscreatedat': subscreatedAt,
        'subscriptionExpirationDate': subscriptionExpirationDate,
        //TODO check this
        'reviews': reviews != null ? List<dynamic>.from(reviews!) : null,
        'orders': orders != null ? List<dynamic>.from(orders!) : null,
      };
}
