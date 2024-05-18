import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/cart_provider.dart';
import 'package:resto/models/dish.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/screens/details/components/dish_item_card.dart';
import 'package:resto/services/dish_service.dart';

import '../../constants.dart';
import '../search/search_screen.dart';
import 'components/featured_items.dart';
import 'components/iteams.dart';
import 'components/restaurant_info.dart';

class DetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const DetailsScreen({super.key, required this.restaurant});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Dish> _dishes = [];

  @override
  void initState() {
    super.initState();
    _fetchDishes();
  }

  Future<void> _fetchDishes() async {
    try {
      List<Dish> dishes = await DishService()
          .getDishesForRestaurant(widget.restaurant.restaurantId);
      setState(() {
        _dishes = dishes;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('details_screen.dart: $_dishes');
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(widget.restaurant.imageUrl,
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                RestaurantInfo(
                  restaurant: widget.restaurant,
                ),
                const SizedBox(height: defaultPadding),
                _dishes.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _dishes.map((dish) {
                          return DishItemCard(
                            dish: dish,
                            press: () {
                              print('clicked');
                              cart.addItem(dish);
                            },
                          );
                        }).toList(),
                      )
                    : Text(
                        "No Dishes Found For This Restaurant",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
