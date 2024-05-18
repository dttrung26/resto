import 'package:flutter/material.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/services/restaurant_service.dart';

class UpdateRestoForm extends StatefulWidget {
  final User user;
  const UpdateRestoForm({super.key, required this.user});

  @override
  State<UpdateRestoForm> createState() => _UpdateRestoFormState();
}

class _UpdateRestoFormState extends State<UpdateRestoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _restoNameController = TextEditingController();
  final TextEditingController _restoDescriptionController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _restoNameController,
            decoration: const InputDecoration(labelText: 'Resto Name'),
          ),
          TextFormField(
            controller: _restoDescriptionController,
            decoration: const InputDecoration(labelText: 'Resto Description'),
          ),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Resto Category'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Resto Address'),
          ),
          TextFormField(
            controller: _postcodeController,
            decoration: const InputDecoration(labelText: 'Resto Postcode'),
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Resto Phone'),
          ),
          TextFormField(
            controller: _imageURLController,
            decoration: const InputDecoration(labelText: 'Resto Image URL'),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Restaurant resto = Restaurant(
                    restaurantId: 0,
                    restaurantName: _restoNameController.text,
                    description: _restoDescriptionController.text,
                    imageUrl: _imageURLController.text,
                    category: _categoryController.text,
                    address: _addressController.text,
                    postcode: _postcodeController.text,
                    phone: _phoneController.text,
                    userId: widget.user.userID);
                await RestaurantService()
                    .createRestaurant(resto)
                    .then((value) => {
                          if (value)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Create resto successfully!'),
                                ),
                              )
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Create resto failed!'),
                                ),
                              )
                            }
                        });
              },
              child: const Text('Update Restaurant'),
            ),
          ),
        ],
      ),
    );
  }
}
