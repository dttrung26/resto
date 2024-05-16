import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resto/entry_point.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/profile/components/location_form.dart';

import '../../components/buttons/secondery_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class LocationScreen extends StatelessWidget {
  final User user;
  const LocationScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Update your location ",
                text:
                    "Please enter your location and postcoded to \nyour location to find restaurants near you.",
              ),

              // Getting Current Location
              SeconderyButton(
                press: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/location.svg",
                      height: 24,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Use current location",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: primaryColor),
                    )
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              user.address!.isNotEmpty
                  ? Text(
                      "Your current location: ${user.address}, ${user.postcode}")
                  : const Text("User has not updated location"),
              const SizedBox(height: defaultPadding),
              LocationForm(
                userId: user.userID,
              ),

              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
