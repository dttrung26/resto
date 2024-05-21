import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resto/constants.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/add_card_form.dart';
import 'package:resto/screens/profile/components/balance_form.dart';
import 'package:resto/services/auth_service.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CardScreen extends StatefulWidget {
  final int userId;
  const CardScreen({super.key, required this.userId});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = AuthService.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    String sillyValidFrom = '5/24';
    String sillyValidTo = '5/27';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Payment Methods"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: FutureBuilder<User?>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('User not found'));
                } else {
                  User user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: defaultPadding),
                      Text("Manage Payment Methods",
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text(
                        "Add or Update your payment methods",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 15),
                      user.cardNumber != null
                          ? CreditCardUi(
                              cardHolderFullName: user.username,
                              cardNumber: user.cardNumber!,
                              validFrom: sillyValidFrom,
                              validThru: sillyValidTo,
                            )
                          : AddCardForm(userId: user.userID),
                      const SizedBox(height: 15),
                      Text("Balance: \$${user.balance}",
                          style: Theme.of(context).textTheme.headlineMedium),
                      user.cardNumber != null
                          ? BalanceForm(userId: user.userID)
                          : Container(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
