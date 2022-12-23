import 'package:dicoding_flutter_fundamental/common/error_message_widget.dart';
import 'package:dicoding_flutter_fundamental/common/loading_widget.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_page.dart';
import 'package:dicoding_flutter_fundamental/pages/home/home_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchTextController = TextEditingController();

  late HomeProvider homeProvider;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Daftar Restoran"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchBox(context),
              _buildRestaurantList(context),
            ],
          ),
        ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchTextController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Cari Restoran Favoritemu"
        ),
        onChanged: (text) {
          Provider.of<HomeProvider>(context, listen: false).findData(text);
        },
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.success) {
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, state.restaurants[index]);
              }
          );
        } else if (state.state == ResultState.loading) {
          return const LoadingWidget();
        } else if (state.state == ResultState.empty) {
          return ErrorMessageWidget(message: "Restoran tidak ditemukan, silahkan cari dengan kata kunci yang lain");
        } else {
          return ErrorMessageWidget(message: "Gagal menampilkan detail restoran, silahkan coba lagi");
        }
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      leading: Image.network(
        "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
        width: 100,
      ),
      title: Text(restaurant.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          top: 8
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            RatingBarIndicator(
                rating: restaurant.rating,
                itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber
                ),
              itemCount: 5,
              itemSize: 16,
              direction: Axis.horizontal,
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
