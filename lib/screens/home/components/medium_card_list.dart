import 'package:flutter/material.dart';
import 'package:resto/models/restaurant.dart';

import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../../demoData.dart';
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
  // bool isLoading = true;
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // only for demo
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
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: (data.length - 1) == index ? defaultPadding : 0,
              ),
              child: RestaurantInfoMediumCard(
                // image: data[index]['image'],
                image: widget.restaurantList[index].imageUrl,
                name: widget.restaurantList[index].restaurantName,
                location: widget.restaurantList[index].address,
                delivertTime: 25,
                rating: widget.restaurantList[index].averageReview ?? 0.0,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailsScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
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
