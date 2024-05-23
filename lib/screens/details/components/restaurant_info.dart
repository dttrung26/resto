import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resto/models/restaurant.dart';
import '../../../components/price_range_and_food_type.dart';
import '../../../components/rating_with_counter.dart';
import '../../../constants.dart';

class RestaurantInfo extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.restaurantName,
          style: Theme.of(context).textTheme.headlineMedium,
          maxLines: 1,
        ),
        const SizedBox(height: defaultPadding / 2),
        PriceRangeAndFoodtype(
          foodType: [restaurant.category],
        ),
        const SizedBox(height: defaultPadding / 2),
        RatingWithCounter(
            rating: double.parse(restaurant.averageReview!.toStringAsFixed(2)),
            numOfRating: restaurant.reviews!.length),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            const DeliveryInfo(
              iconSrc: "assets/icons/delivery.svg",
              text: "Standard",
              subText: "Delivery",
            ),
            const SizedBox(width: defaultPadding),
            const DeliveryInfo(
              iconSrc: "assets/icons/clock.svg",
              text: "25",
              subText: "Minutes",
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Take away"),
            ),
          ],
        ),
      ],
    );
  }
}

class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    required this.subText,
  });

  final String iconSrc, text, subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          color: primaryColor,
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}
