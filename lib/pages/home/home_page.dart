import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_list.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Restaurant> allRestaurants = [];
  List<Restaurant> restaurants = [];
  TextEditingController searchTextController = TextEditingController();

  Future getRestaurantList() async {
    final String jsonString = await rootBundle.loadString("assets/local_restaurant.json");

    setState((){
      allRestaurants = RestaurantList.fromRawJson(jsonString).restaurants;
      restaurants = RestaurantList.fromRawJson(jsonString).restaurants;
    });
  }

  Future searchRestaurant(text) async {
    setState(() {
      restaurants = allRestaurants.where((element) => element.name.toLowerCase().contains(text.toString().toLowerCase())).toList();
    });
  }
  
  @override
  void initState() {
    super.initState();
    
    getRestaurantList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Applications"),
      ),
      body: Column(
        children: [
          _buildSearchBox(),
          Expanded(
              child: _buildRestaurantList(context)
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: searchTextController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Cari Restoran Favoritemu"
        ),
        onChanged: (text) {
          searchRestaurant(text);
        },
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    if (restaurants.isNotEmpty) {
      return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return _buildRestaurantItem(context, restaurants[index]);
          });
    } else {
      return const Text("Tidak ada restoran ditemukan");
    }
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      leading: Image.network(
        restaurant.pictureId,
        width: 100,
      ),
      title: Text(restaurant.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          top: 8
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.pin_drop,
                  size: 16,
                  color: Colors.black,
                ),
                Text(restaurant.city)
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.black,
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        navigateToRestaurantDetail(context, restaurant);
      },
    );
  }

  void navigateToRestaurantDetail(BuildContext context, Restaurant restaurant) {
    Navigator.pushNamed(context, RestaurantDetailPage.routeName, arguments: restaurant);
  }
}
