class Dish {
  final int dishId;
  final String name;
  final double price;
  final String imageUrl;
  final int restaurantId;

  Dish({
    required this.dishId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      dishId: json['dishId'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      imageUrl: json['imageUrl'] == ''
          ? 'https://cdn-icons-png.freepik.com/512/282/282465.png'
          : json['imageUrl'],
      restaurantId: json['resturantID'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'resturantId': restaurantId,
    };
  }
}
