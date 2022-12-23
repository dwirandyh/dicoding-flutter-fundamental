import 'package:dicoding_flutter_fundamental/common/error_message_widget.dart';
import 'package:dicoding_flutter_fundamental/common/loading_widget.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_page.dart';
import 'package:dicoding_flutter_fundamental/pages/favorite/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    reloadData();
  }

  void reloadData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FavoriteProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Restoran"),
      ),
      body: Column(
        children: [
          _buildSearchBox(context),
          Expanded(child: _buildRestaurantList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchTextController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "Cari Restoran Favoritemu"),
        onChanged: (text) {
          Provider.of<FavoriteProvider>(context, listen: false).findData(text);
        },
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.success) {
          return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(context, state.restaurants[index]);
              });
        } else if (state.state == ResultState.loading) {
          return const LoadingWidget();
        } else if (state.state == ResultState.empty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: ErrorMessageWidget(
                message:
                    "Restoran tidak ditemukan, silahkan cari dengan kata kunci yang lain"),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: ErrorMessageWidget(
                message:
                    "Gagal menampilkan detail restoran, silahkan coba lagi"),
          );
        }
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      leading: Image.network(
        "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
        width: 100,
      ),
      title: Text(restaurant.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
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
    Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant)
        .then((value) {
      reloadData();
    });
  }
}
