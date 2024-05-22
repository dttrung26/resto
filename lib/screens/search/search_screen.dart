import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:resto/components/order_helper.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/models/restaurant.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/details/details_screen.dart';
import 'package:resto/services/restaurant_service.dart';

import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Restaurant> _searchResults = [];
  String _selectedCategory = 'Asian';

  void _search(String keywords) async {
    try {
      List<Restaurant> results =
          await RestaurantService().searchRestaurants(keywords);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Search Screen"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search by keyword...',
                ),
                onSubmitted: (_) => _search(_searchController.text),
              ),
              const SizedBox(
                height: 20,
              ),
              kOrText,
              Row(
                children: [
                  const Text("Search by category: "),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                        _search(_selectedCategory);
                      });
                    },
                    items: <String>['Asian', 'Fast Food', 'Indian', 'American']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: _searchResults != []
                    ? ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final restaurant = _searchResults[index];
                          var distance =
                              DistanceHelper(restaurant: restaurant, user: user)
                                  .calculateDistance();
                          return RestaurantInfoBigCard(
                            name: restaurant.restaurantName,
                            rating: restaurant.averageReview ?? 0,
                            numOfRating: restaurant.reviews?.length ?? 0,
                            deliveryTime: ((distance / 50) * 60).toInt(),
                            images: [restaurant.imageUrl],
                            foodType: [restaurant.category],
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    restaurant: restaurant,
                                    estimatedTime:
                                        ((distance / 50) * 60).toInt(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Text("No restaurant found"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          // get data while typing
          // if (value.length >= 3) showResult();
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            // If all data are correct then save data to out variables
            _formKey.currentState!.save();

            // Once user pree on submit
          } else {}
        },
        validator: requiredValidator,
        style: Theme.of(context).textTheme.labelLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search on Resto",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: bodyTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
