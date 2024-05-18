import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/controllers/cart_provider.dart';
import 'package:resto/models/dish.dart';
import 'package:resto/models/order.dart';
import 'package:resto/screens/orderDetails/delivery_screen.dart';
import 'package:resto/services/auth_service.dart';
import 'package:resto/services/user_service.dart';
import 'package:resto/services/order_service.dart';
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
    List<double> deliveryPrices = [3.5, 5.5, 7.7, 10.0];
    Random random = Random();
    int randomIndex = random.nextInt(deliveryPrices.length);
    double sillyDelivery = deliveryPrices[randomIndex];

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

                    Dish? firstItem =
                        cart.items.isNotEmpty ? cart.items.values.first : null;
                    // silly 45 for little viet
                    Order order = Order(
                        dateTime: DateTime.now(),
                        orderId: 0,
                        isProcessed: false,
                        isDone: false,
                        totalPrice: totalPrice,
                        userID: user.userID,
                        restaurantId: firstItem?.restaurantId ?? 47,
                        isReady: false,
                        isDelivered: false,
                        driverId: null,
                        restaurantName: '',
                        dishes: []);
                    // dishes: cart.items.values.toList());

                    await OrderService().postOrder(order).then((myOrder) {
                      if (myOrder != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create order successfully!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create order failed!'),
                          ),
                        );
                      }
                    });
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
