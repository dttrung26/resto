import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:resto/components/cards/big/restaurant_info_big_card.dart';
import 'package:resto/constants.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/update_resto_form.dart';
import 'package:resto/services/restaurant_service.dart';

class UpdateRestaurantScreen extends StatefulWidget {
  final User user;
  const UpdateRestaurantScreen({super.key, required this.user});

  @override
  State<UpdateRestaurantScreen> createState() => _UpdateRestaurantScreenState();
}

class _UpdateRestaurantScreenState extends State<UpdateRestaurantScreen> {
  Restaurant? _resto;
  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    _resto =
        await RestaurantService().getRestaurantByUserId(widget.user.userID);
    if (mounted) {
      setState(() {}); // Trigger a rebuild
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
                Text("Create Restaurant",
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  "Create or update your restaurant information method",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                _resto == null
                    ? UpdateRestoForm(user: widget.user)
                    : RestaurantInfoBigCard(
                        name: _resto!.restaurantName,
                        rating: _resto!.averageReview ?? 0,
                        numOfRating: _resto!.reviews?.length ?? 0,
                        deliveryTime: 25,
                        images: [_resto!.imageUrl],
                        foodType: [_resto!.category],
                        press: () {},
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
