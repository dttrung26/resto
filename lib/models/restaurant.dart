class Restaurant {
  final int restaurantId;
  final String restaurantName;
  final String description;
  final String imageUrl;
  final String category;
  final String address;
  final String postcode;
  final String phone;
  final double? averageReview;
  final int userId;
  final List<String>? dishes;
  final List<String>? reviews;
  final List<String>? orders;

  Restaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.address,
    required this.postcode,
    required this.phone,
    this.averageReview,
    this.dishes,
    this.reviews,
    this.orders,
    required this.userId,
  });

  // Convert a Restaurant object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'resturantId': restaurantId,
      'resturantName': restaurantName,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'address': address,
      'postcode': postcode,
      'phone': phone,
      'averageReview': averageReview,
      'dishes': dishes,
      'reviews': reviews,
      'orders': orders,
      'userId': userId,
    };
  }

  // Create a Restaurant object from a Map<String, dynamic>
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['resturantId'],
      restaurantName: json['resturantName'],
      description: json['description'],
      //default feature image
      imageUrl: json['imageUrl'] == ''
          ? 'https://cdn.otstatic.com/legacy-cw/default2-original.png'
          : json['imageUrl'],
      category: json['category'],
      address: json['address'],
      postcode: json['postcode'],
      phone: json['phone'],
      userId: json['userId'],
      averageReview: json['averageReview'] ?? 0.0,
      dishes: List<String>.from(json['dishes'] ?? []),
      reviews: List<String>.from(json['reviews'] ?? []),
      orders: List<String>.from(json['orders'] ?? []),
    );
  }
}
