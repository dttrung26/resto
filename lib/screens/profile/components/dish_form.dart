import 'package:flutter/material.dart';
import 'package:resto/models/dish.dart';
import 'package:resto/services/dish_service.dart';

class UpdateDishForm extends StatefulWidget {
  final int restaurantId;
  const UpdateDishForm({super.key, required this.restaurantId});

  @override
  State<UpdateDishForm> createState() => _UpdateDishFormState();
}

class _UpdateDishFormState extends State<UpdateDishForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Dish Name ..."),
          ),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: "Price ..."),
          ),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: "Image URL ..."),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                var dish = Dish(
                  dishId: 0,
                  name: _nameController.text,
                  price: double.parse(_priceController.text),
                  imageUrl: _imageUrlController.text,
                  restaurantId: widget.restaurantId,
                );
                await DishService()
                    .createDishPerRestaurant(dish)
                    .then((value) => {
                          if (value)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Create dish successfully!'),
                                ),
                              )
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Create dish failed!'),
                                ),
                              )
                            }
                        });
              },
              child: const Text('Update Dish'),
            ),
          ),
        ],
      ),
    );
  }
}
