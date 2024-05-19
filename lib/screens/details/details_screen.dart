import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/cart_provider.dart';
import 'package:resto/models/dish.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/review.dart';
import 'package:resto/screens/details/components/dish_item_card.dart';
import 'package:resto/screens/details/components/start_review.dart';
import 'package:resto/services/dish_service.dart';
import 'package:resto/services/review_service.dart';

import '../../constants.dart';
import '../search/search_screen.dart';
import 'components/featured_items.dart';
import 'components/iteams.dart';
import 'components/restaurant_info.dart';

class DetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  final int estimatedTime;
  const DetailsScreen(
      {super.key, required this.restaurant, required this.estimatedTime});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Dish> _dishes = [];
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchDishes();
    _fetchReviews();
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

  Future<void> _fetchReviews() async {
    try {
      List<Review> reviews = await ReviewService()
          .getReviewByRestaurant(widget.restaurant.restaurantId);

      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'details_screen.dart: ${widget.restaurant.restaurantId} : ${widget.restaurant.restaurantName}');
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
                _reviews.isNotEmpty
                    ? Container(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _reviews.map((review) {
                                return ListTile(
                                  title: StarRating(starRating: review.star),
                                  subtitle: Text(review.reviewContent),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "No Reviews Found For This Restaurant",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                const SizedBox(height: defaultPadding),
                _dishes.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _dishes.map((dish) {
                          return DishItemCard(
                            dish: dish,
                            press: () {
                              cart.addItem(dish);
                            },
                          );
                        }).toList(),
                      )
                    : Text(
                        "No Dishes Found For This Restaurant",
                        style: Theme.of(context).textTheme.titleSmall,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
