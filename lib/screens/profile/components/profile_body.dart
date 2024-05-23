import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:resto/constants.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/card_screen.dart';
import 'package:resto/screens/profile/dish_screen.dart';
import 'package:resto/screens/profile/location_screen.dart';
import 'package:resto/screens/profile/order_management_restaurant.dart';
import 'package:resto/screens/profile/order_management_user.dart';
import 'package:resto/screens/profile/revenue_screen.dart';
import 'package:resto/screens/profile/subscription_screen.dart';
import 'package:resto/screens/profile/update_restaurant_screen.dart';
import 'package:resto/services/restaurant_service.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context, listen: true).user!;
    bool isRestoOwner = user.role == "restaurant";
    bool isNormalUser = user.role == "user";
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                Text("Account Settings",
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(
                  "Update your settings like notifications, payments, profile edit etc.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                // isNormalUser
                //     ? ProfileMenuCard(
                //         svgSrc: "assets/icons/profile.svg",
                //         title: "Profile Information",
                //         subTitle: "Change your account information",
                //         press: () {},
                //       )
                //     : Container(),
                // isNormalUser
                //     ? ProfileMenuCard(
                //         svgSrc: "assets/icons/lock.svg",
                //         title: "Change Password",
                //         subTitle: "Change your password",
                //         press: () {},
                //       )
                //     : Container(),
                isNormalUser
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/card.svg",
                        title: "Payment Methods",
                        subTitle: "Add your credit & debit cards",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardScreen(userId: user.userID),
                            ),
                          );
                        },
                      )
                    : Container(),
                isNormalUser
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/marker.svg",
                        title: "Locations",
                        subTitle: "Add or remove your delivery locations",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LocationScreen(
                                user: user,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
                isNormalUser
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/fast-delivery.svg",
                        title: "Subscription",
                        subTitle: "Update or remove your subscription status",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SubscriptionScreen(),
                            ),
                          );
                        },
                      )
                    : Container(),
                isNormalUser
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/cart.svg",
                        title: "Orders",
                        subTitle: "Manage your orders history",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderManagementUser(
                                user: user,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
                isRestoOwner
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/resto.svg",
                        title: "Restaurant Management",
                        subTitle:
                            "Create or update your restaurant information",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateRestaurantScreen(user: user),
                            ),
                          );
                        },
                      )
                    : Container(),
                isRestoOwner
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/dish.svg",
                        title: "Menu Management",
                        subTitle: "Create or update your menu information",
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DishScreen(user: user),
                            ),
                          );
                        },
                      )
                    : Container(),
                isRestoOwner
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/cart.svg",
                        title: "Orders Management",
                        subTitle: "Manage restaurant order history",
                        press: () async {
                          Restaurant? restaurant = await RestaurantService()
                              .getRestaurantByUserId(user.userID);
                          if (restaurant != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderManagementRestaurant(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
                isRestoOwner
                    ? ProfileMenuCard(
                        svgSrc: "assets/icons/clock.svg",
                        title: "Revenue Management",
                        subTitle: "Manage restaurant revenue per duration",
                        press: () async {
                          Restaurant? restaurant = await RestaurantService()
                              .getRestaurantByUserId(user.userID);
                          if (restaurant != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RevenueScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
                // ProfileMenuCard(
                //   svgSrc: "assets/icons/fb.svg",
                //   title: "Add Social Account",
                //   subTitle: "Add Facebook, Twitter etc ",
                //   press: () {},
                // ),
                // ProfileMenuCard(
                //   svgSrc: "assets/icons/share.svg",
                //   title: "Refer to Friends",
                //   subTitle: "Get \$10 for reffering friends",
                //   press: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    Key? key,
    this.title,
    this.subTitle,
    this.svgSrc,
    this.press,
  }) : super(key: key);

  final String? title, subTitle, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SvgPicture.asset(
                svgSrc!,
                height: 24,
                width: 24,
                color: titleColor.withOpacity(0.64),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: titleColor.withOpacity(0.54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
