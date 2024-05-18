import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/user.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/user_service.dart';

class SubscriptionForm extends StatefulWidget {
  final User user;
  const SubscriptionForm({super.key, required this.user});

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  bool _isMonthlySelected = false;
  bool _isYearlySelected = false;
  bool _isCancelled = false;
  double _subsriptionPrice = 0.0;
  void _handleMonthlySelected(bool? value) {
    if (value != null) {
      setState(() {
        _isMonthlySelected = value;
        _subsriptionPrice = 10.0;
        if (value) {
          _isYearlySelected = false;
          _isCancelled = false;
        }
      });
    }
  }

  void _handleYearlySelected(bool? value) {
    if (value != null) {
      setState(() {
        _isYearlySelected = value;
        _subsriptionPrice = 100.0;
        if (value) {
          _isMonthlySelected = false;
          _isCancelled = false;
        }
      });
    }
  }

  void _handleCancelSelected(bool? value) {
    if (value != null) {
      setState(() {
        _isCancelled = value;
        _subsriptionPrice = 0.0;
        if (value) {
          _isMonthlySelected = false;
          _isYearlySelected = false;
        }
      });
    }
  }

  void _handleSubmit() async {
    double balance = widget.user.balance;
    if (balance < _subsriptionPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Your remaining balance is not enough to make this transaction.'),
        ),
      );
    } else {
      double newBalance = balance - _subsriptionPrice;
      if (_isMonthlySelected) {
        UserService().updateSubscriptionMethod(widget.user.userID, true, 1);
      } else if (_isYearlySelected) {
        UserService().updateSubscriptionMethod(widget.user.userID, true, 12);
      } else if (_isCancelled) {
        UserService().updateSubscriptionMethod(widget.user.userID, false, 0);
      } else {
        print('Please select a subscription option');
      }
      await UserService().updateBalance(widget.user.userID, newBalance);
      var updatedUser = await AuthService.getUserById(widget.user.userID);
      if (updatedUser != null) {
        Provider.of<AuthProvider>(context, listen: false).setUser(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription updated successfully!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose a subscription option:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Perk: Free Delivery',
          style: TextStyle(fontSize: 15.0),
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Checkbox(
              value: _isMonthlySelected,
              onChanged: _handleMonthlySelected,
            ),
            Text('One Month - \$10'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isYearlySelected,
              onChanged: _handleYearlySelected,
            ),
            const Text('One Year - \$100'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isCancelled,
              onChanged: _handleCancelSelected,
            ),
            const Text('Cancel subscription - No refund'),
          ],
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
