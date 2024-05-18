import 'package:flutter/material.dart';
import 'package:resto/constants.dart';
import 'package:resto/models/dish.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/dish_form.dart';
import 'package:resto/services/dish_service.dart';
import 'package:resto/services/restaurant_service.dart';

class DishScreen extends StatefulWidget {
  final User user;
  const DishScreen({super.key, required this.user});

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  List<Dish> _dishes = [];
  Restaurant? _resto;

  @override
  void initState() {
    super.initState();
    _loadDishesPerRestaurant();
  }

  Future<void> _loadDishesPerRestaurant() async {
    await RestaurantService()
        .getRestaurantByUserId(widget.user.userID)
        .then((resto) async {
      if (resto != null) {
        _resto = resto;
        _dishes =
            await DishService().getDishesForRestaurant(resto.restaurantId);
      } else {
        print("User has not created restaurant");
      }
    }).catchError((e) {
      print(e);
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                Text("Menu Management",
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  "Create or update your menu's dishes",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                _resto != null
                    ? UpdateDishForm(
                        restaurantId: _resto!.restaurantId,
                      )
                    : const Text("User has not created a restaurant"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
