import 'package:flutter/material.dart';
import 'package:resto/models/dish.dart';

class CartProvider with ChangeNotifier {
  Map<int, Dish> _items = {};

  Map<int, Dish> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, dish) {
      total += dish.price;
    });
    return total;
  }

  void addItem(Dish dish) {
    _items.update(
      dish.dishId,
      (existingDish) => Dish(
        dishId: existingDish.dishId,
        name: existingDish.name,
        price: existingDish.price,
        imageUrl: existingDish.imageUrl,
        restaurantId: existingDish.restaurantId,
      ),
      ifAbsent: () => dish,
    );
    print(_items);
    notifyListeners();
  }

  void removeItem(int dishId) {
    _items.remove(dishId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
