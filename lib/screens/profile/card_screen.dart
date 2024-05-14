import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context, listen: false);
    String sillyValidThru = (['10/25', '11/25', '12/25', '05/25', '06/25']
      ..shuffle()
      ..first) as String;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text("Manage Payment Methods",
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(
                "Add or Update your payment methods",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              user.user!.cardNumber == null
                  ? CreditCardUi(
                      cardHolderFullName: user.user!.username,
                      cardNumber: user.user!.cardNumber ?? "N/A",
                      validThru: sillyValidThru,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
