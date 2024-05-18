import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/controllers/cart_provider.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/user_service.dart';

import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double sillyDelivery =
        double.parse((Random().nextDouble() * 10).toStringAsFixed(2));
    final cart = Provider.of<CartProvider>(context, listen: true);
    final user = Provider.of<AuthProvider>(context, listen: true).user;
    bool doesUserHasSubcription = user!.hasSubscription!;
    var deliveryPrice = doesUserHasSubcription ? 0.0 : sillyDelivery;
    var totalPrice = deliveryPrice + cart.totalAmount;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              cart.itemCount != 0
                  ? Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: cart.itemCount,
                        itemBuilder: (ctx, i) {
                          var dish = cart.items.values.toList()[i];
                          return OrderedItemCard(
                            dish: dish,
                          );
                        },
                      ),
                    )
                  : Image.asset(
                      'assets/images/empty_cart.png',
                      fit: BoxFit.cover,
                    ),
              doesUserHasSubcription
                  ? const Text(
                      "Free Delivery has been applied for subscribed user")
                  : Container(),
              const SizedBox(height: defaultPadding),
              Text("Your remaining balance: \$${user!.balance}"),
              const SizedBox(height: defaultPadding / 2),
              PriceRow(text: "Subtotal", price: cart.totalAmount),
              const SizedBox(height: defaultPadding / 2),
              PriceRow(
                  text: "Delivery",
                  price: doesUserHasSubcription ? 0.0 : sillyDelivery),
              const SizedBox(height: defaultPadding / 2),
              TotalPrice(price: totalPrice),
              const SizedBox(height: defaultPadding * 2),
              PrimaryButton(
                text: "Checkout (A\$$totalPrice)",
                press: () async {
                  var userBalance = user.balance;
                  if (userBalance < totalPrice) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Your remaining balance is not enough to make this transaction.'),
                      ),
                    );
                  } else {
                    var newBalance = userBalance - totalPrice;
                    await UserService().updateBalance(user.userID, newBalance);
                    var updatedUser =
                        await AuthService.getUserById(user.userID);
                    if (updatedUser != null) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .setUser(updatedUser);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment proceeded successfully!'),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
