import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';

import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';

class MediumCardList extends StatefulWidget {
  final List<Restaurant> restaurantList;
  const MediumCardList({
    Key? key,
    required this.restaurantList,
  }) : super(key: key);

  @override
  _MediumCardListState createState() => _MediumCardListState();
}

class _MediumCardListState extends State<MediumCardList> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context).user!;

    List data = widget.restaurantList..shuffle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 254,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var distance = DistanceHelper(
                        restaurant: widget.restaurantList[index], user: user)
                    .calculateDistance();
                return Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: (data.length - 1) == index ? defaultPadding : 0,
                  ),
                  child: RestaurantInfoMediumCard(
                    // image: data[index]['image'],
                    image: widget.restaurantList[index].imageUrl,
                    name: widget.restaurantList[index].restaurantName,
                    location: widget.restaurantList[index].address,
                    delivertTime: ((distance / 50) * 60).toInt(),
                    rating: double.parse(widget
                            .restaurantList[index].averageReview!
                            .toStringAsFixed(2)) ??
                        0.0,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                              restaurant: widget.restaurantList[index],
                              estimatedTime: ((distance / 50) * 60).toInt()),
                        ),
                      );
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  SingleChildScrollView buildFeaturedPartnersLoadingIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(left: defaultPadding),
            child: MediumCardScalton(),
          ),
        ),
      ),
    );
  }
}
