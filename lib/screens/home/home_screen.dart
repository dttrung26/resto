import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/services/restaurant_service.dart';

import '../../components/cards/big/big_card_image_slide.dart';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../demoData.dart';
import '../filter/filter_screen.dart';
import '../details/details_screen.dart';
import '../featured/featurred_screen.dart';
import 'components/medium_card_list.dart';
import 'components/promotion_banner.dart';
import 'package:resto/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<AuthProvider>(context, listen: false).user!;
    final restaurantService = RestaurantService();
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            // Text("G'day ${user.username}"),
            Text(
              "Delivery to".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            ),
            const Text(
              "35 Daisy St, Fairy Meadow",
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              //Big card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: BigCardImageSlide(images: demoBigImages),
              ),
              const SizedBox(height: defaultPadding * 2),
              SectionTitle(
                title: "Best Pick",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //Medium Card FutureBuilder
              FutureBuilder<List<Restaurant>>(
                future: restaurantService.getRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<Restaurant> restaurants = snapshot.data!;
                    if (restaurants == []) {
                      return Text("Empty Restaurants data");
                    } else {
                      return MediumCardList(
                        restaurantList: restaurants,
                      );
                    }
                  } else {
                    return const Center(child: Text('Snapshot has no data.'));
                  }
                },
              ),

              // SectionTitle(
              //   title: "Cate 2",
              //   press: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const FeaturedScreen(),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: defaultPadding),
              // const MediumCardList(
              //   restaurant: Restaurant,
              // ),
              const SizedBox(height: 20),
              // Banner
              // const PromotionBanner(),
              // const SizedBox(height: 20),
              // SectionTitle(
              //   title: "Best Pick",
              //   press: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const FeaturedScreen(),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // const MediumCardList(),
              const PromotionBanner(),
              const SizedBox(height: 16),
              SectionTitle(
                title: "All Restaurant",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeaturedScreen(),
                  ),
                ),
              ),
              FutureBuilder<List<Restaurant>>(
                future: restaurantService.getRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<Restaurant> restaurants = snapshot.data!;
                    if (restaurants.isEmpty) {
                      return const Center(
                          child: Text("Empty Restaurants data"));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Column(
                          children: restaurants.map((restaurant) {
                            return RestaurantInfoBigCard(
                              name: restaurant.restaurantName,
                              rating: restaurant.averageReview ?? 0,
                              numOfRating: restaurant.reviews?.length ?? 0,
                              deliveryTime: 25,
                              images: [restaurant.imageUrl],
                              foodType: [restaurant.category],
                              press: () {},
                            );
                          }).toList(),
                        ),
                      );
                    }
                  } else {
                    return const Center(child: Text('Snapshot has no data.'));
                  }
                },
              ),
              // const SizedBox(height: 16),
              // // Demo list of Big Cards
              // ...List.generate(
              //   // For demo we use 4 items
              //   3,
              //   (index) => Padding(
              //     padding: const EdgeInsets.fromLTRB(
              //         defaultPadding, 0, defaultPadding, defaultPadding),
              //     child: RestaurantInfoBigCard(
              //       // Images are List<String>
              //       images: demoBigImages..shuffle(),
              //       name: "McDonald's",
              //       rating: 4.3,
              //       numOfRating: 200,
              //       deliveryTime: 25,
              //       foodType: const ["Chinese", "American", "Deshi food"],
              //       press: () => Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const DetailsScreen(),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
