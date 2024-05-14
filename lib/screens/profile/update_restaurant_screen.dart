import 'dart:ffi';
import 'package:flutter/material.dart';
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
      setState(() {}); // Trigger a rebuild after getting resto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Screen"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                Text("Create Restaurant Information",
                    style: Theme.of(context).textTheme.headlineMedium),
                UpdateRestoForm(user: widget.user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
