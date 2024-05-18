import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/cart_provider.dart';
import 'package:resto/models/dish.dart';

import '../../../constants.dart';

class OrderedItemCard extends StatefulWidget {
  final Dish dish;
  const OrderedItemCard({
    super.key,
    required this.dish,
  });

  @override
  State<OrderedItemCard> createState() => _OrderedItemCardState();
}

class _OrderedItemCardState extends State<OrderedItemCard> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    List<String> dishDescriptions = [
      "A hearty and flavorful pasta dish",
      "Tender and juicy grilled chicken",
      "A crispy and delicious dish",
      "A fresh and crunchy one",
      "Savory and spicy beef dish, served with a variety",
      "Toppings including lettuce, cheese, and salsa."
    ];
    dishDescriptions.shuffle();
    String sillyDescription = dishDescriptions.first;

    return Dismissible(
      key: ValueKey(widget.dish.dishId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(widget.dish.dishId);
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NumOfItems(numOfItem: 1),
              const SizedBox(width: defaultPadding * 0.75),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dish.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    Text(
                      sillyDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                "A\$${widget.dish.price}",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: primaryColor),
              )
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          const Divider(),
        ],
      ),
    );
  }
}

class NumOfItems extends StatelessWidget {
  const NumOfItems({
    super.key,
    required this.numOfItem,
  });

  final int numOfItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
            width: 0.5, color: const Color(0xFF868686).withOpacity(0.3)),
      ),
      child: Text(
        numOfItem.toString(),
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: primaryColor),
      ),
    );
  }
}
