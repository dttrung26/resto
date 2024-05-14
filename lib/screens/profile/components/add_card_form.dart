import 'package:flutter/material.dart';

class AddCardForm extends StatefulWidget {
  const AddCardForm({super.key});

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        TextFormField(
          controller: _balanceController,
          decoration: InputDecoration(labelText: 'Balance'),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: 16.0),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Get the updated values
              String updatedCardNumber = _cardNumberController.text;
              double updatedBalance = double.parse(_balanceController.text);

              // Perform the update operation (e.g., send to backend)
              // Here you can handle updating the card and balance

              // Show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Card and balance updated successfully!'),
                ),
              );
            },
            child: Text('Update'),
          ),
        ),
      ],
    );
  }
}
