import 'package:flutter/material.dart';
import 'package:resto/models/review.dart';

class StarRating extends StatelessWidget {
  final int starRating;

  const StarRating({
    Key? key,
    required this.starRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < starRating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
