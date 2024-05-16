import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/user_service.dart';

class BalanceForm extends StatefulWidget {
  final int userId;
  const BalanceForm({super.key, required this.userId});

  @override
  State<BalanceForm> createState() => _BalanceFormState();
}

class _BalanceFormState extends State<BalanceForm> {
  final TextEditingController _balanceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _balanceController,
          decoration: const InputDecoration(labelText: 'Balance'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              double updatedBalance = double.parse(_balanceController.text);
              await UserService()
                  .updateBalance(widget.userId, updatedBalance)
                  .then((value) async {
                if (value) {
                  var updatedUser =
                      await AuthService.getUserById(widget.userId);
                  if (updatedUser != null) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .setUser(updatedUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Balance updated successfully!'),
                      ),
                    );
                  }
                }
              }).catchError((onError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Balance rd update failed ${onError.toString()}'),
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
