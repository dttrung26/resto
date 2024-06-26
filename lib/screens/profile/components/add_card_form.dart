import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/user_service.dart';

class AddCardForm extends StatefulWidget {
  final int userId;
  const AddCardForm({super.key, required this.userId});

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  final TextEditingController _cardNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        // TextFormField(
        //   controller: _balanceController,
        //   decoration: InputDecoration(labelText: 'Balance'),
        //   keyboardType: TextInputType.numberWithOptions(decimal: true),
        // ),
        const SizedBox(height: defaultPadding),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              // double updatedBalance = double.parse(_balanceController.text);
              await UserService()
                  .updatePaymentMethod(
                      widget.userId, _cardNumberController.text)
                  .then((value) async {
                if (value) {
                  var updatedUser =
                      await AuthService.getUserById(widget.userId);
                  if (updatedUser != null) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .setUser(updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Card updated successfully!'),
                      ),
                    );
                  }
                }
              }).catchError((onError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Card update failed ${onError.toString()}'),
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
