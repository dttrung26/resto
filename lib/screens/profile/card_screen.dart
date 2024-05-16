import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/add_card_form.dart';
import 'package:resto/screens/profile/components/balance_form.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context, listen: true).user!;
    String sillyValidFrom = '5/24';
    String sillyValidTo = '5/27';
    return Scaffold(
      appBar: AppBar(
          // title: Text("Manage Payment Methods"),
          ),
      body: SafeArea(
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
                const SizedBox(
                  height: 15,
                ),
                user.cardNumber != null
                    ? CreditCardUi(
                        cardHolderFullName: user.username,
                        cardNumber: user.cardNumber!,
                        validFrom: sillyValidFrom,
                        validThru: sillyValidTo,
                      )
                    : AddCardForm(
                        userId: user.userID,
                      ),
                const SizedBox(
                  height: 15,
                ),
                Text("Balance: \$${user.balance}",
                    style: Theme.of(context).textTheme.headlineMedium),
                user.cardNumber != null
                    ? BalanceForm(
                        userId: user.userID,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
