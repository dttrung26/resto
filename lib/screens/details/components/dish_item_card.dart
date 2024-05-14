import 'package:flutter/material.dart';
import 'package:resto/constants.dart';
import 'package:resto/constants.dart';
import 'package:resto/models/dish.dart';

class DishItemCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback press;
  const DishItemCard({
    Key? key,
    required this.dish,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withOpacity(0.64),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    dish.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 18),
                    ),
                    // Text(
                    //   dish.description,
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    Text(
                      "\$ ${dish.price}",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: primaryColor),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add To Card"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
