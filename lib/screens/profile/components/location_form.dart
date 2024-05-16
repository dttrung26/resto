import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/location_service.dart';

class LocationForm extends StatefulWidget {
  final int userId;
  const LocationForm({super.key, required this.userId});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address ...'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        TextFormField(
          controller: _postcodeController,
          decoration: const InputDecoration(labelText: 'Postcode ...'),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              await LocationService()
                  .updateLocation(widget.userId, _addressController.text,
                      _postcodeController.text)
                  .then((value) async {
                if (value) {
                  var updatedUser =
                      await AuthService.getUserById(widget.userId);
                  if (updatedUser != null) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .setUser(updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location updated successfully!'),
                      ),
                    );
                  }
                }
              }).catchError((onError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Location updated failed ${onError.toString()}'),
                  ),
                );
              });
              // Show a confirmation message
            },
            child: Text('Update'),
          ),
        ),
      ],
    );
  }
}
