import 'package:dicoding_flutter_fundamental/common/error_message_widget.dart';
import 'package:dicoding_flutter_fundamental/common/loading_widget.dart';
import 'package:dicoding_flutter_fundamental/model/menu_detail.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_detail.dart';
import 'package:dicoding_flutter_fundamental/pages/detail/restaurant_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({Key? key, required this.restaurant}) : super(key: key);

  static const String routeName = "detail";
  final Restaurant restaurant;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}
class _RestaurantDetailPageState extends State<RestaurantDetailPage> {

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RestaurantDetailProvider>(context, listen: false).loadRestaurantDetail(widget.restaurant.id);
    });
  }

  void _addOrRemoveFavorite() {
    if (isFavorite) {
      Provider.of<RestaurantDetailProvider>(context, listen: false).deleteFromFavorite(widget.restaurant);
    } else {
      Provider.of<RestaurantDetailProvider>(context, listen: false).addToFavorite(widget.restaurant);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Restoran"),
        actions: [
          _favoriteButton()
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, provider, _) {
                if (provider.state == ResultState.success) {
                  return _buildRestaurantDetail(provider);
                } else if (provider.state == ResultState.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: LoadingWidget(),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: ErrorMessageWidget(message: "Gagal menampilkan detail restoran, silahkan coba lagi"),
                  );
                }
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _favoriteButton() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, _) {
        isFavorite = provider.isFavorite;

        return IconButton(
          icon: provider.isFavorite ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          onPressed: _addOrRemoveFavorite,
        );
      }
    );
  }

  Widget _buildRestaurantDetail(RestaurantDetailProvider state) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(state.restaurantDetail),
          _buildRestaurantAddress(state.restaurantDetail),
          _buildDescription(state.restaurantDetail),
          _buildMenu("Makanan", state.restaurantDetail.menu.foods),
          _buildMenu("Minuman", state.restaurantDetail.menu.drinks)
      ]
    );
  }

  Widget _buildThumbnail(RestaurantDetail restaurantDetail) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://restaurant-api.dicoding.dev/images/medium/${restaurantDetail.pictureId}")
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12)
        ),
      ),
    );
  }

  Widget _buildRestaurantAddress(RestaurantDetail restaurantDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantDetail.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.pin_drop,
                    color: Colors.black,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(restaurantDetail.city),
                ],
              ),
              RatingBarIndicator(
                rating: restaurantDetail.rating,
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
        ],
      ),
    );
  }

  Widget _buildDescription(RestaurantDetail restaurantDetail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Restoran", style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16
          )),
          const SizedBox(height: 8),
          Text(restaurantDetail.description),
        ],
      ),
    );
  }

  Widget _buildMenu(String title, List<MenuDetail> items) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildMenuItem(items[index]);
                    }
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuDetail detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(detail.name),
          ),
        ),
      ),
    );
  }
}
