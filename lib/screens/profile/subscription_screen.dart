import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/subscription_form.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context, listen: true).user!;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                Text("Manage Subscription",
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  "Update or remove your subscription method",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: defaultPadding),
                Text("Your remaining balance: \$${user.balance}"),
                const SizedBox(height: defaultPadding),
                Text(
                    "Your current subscription will expired at ${user.subscriptionExpirationDate}"),
                const SizedBox(height: defaultPadding),
                SubscriptionForm(user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
