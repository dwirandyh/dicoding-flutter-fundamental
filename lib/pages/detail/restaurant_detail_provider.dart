import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_detail.dart';
import 'package:dicoding_flutter_fundamental/service/local_storage_service.dart';
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart';
import 'package:flutter/foundation.dart';

enum ResultState { loading, success, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantService restaurantService;
  final LocalStorageService localStorageService;

  RestaurantDetailProvider(
      {required this.restaurantService, required this.localStorageService});

  late ResultState state = ResultState.loading;
  late RestaurantDetail restaurantDetail;
  late bool isFavorite = false;

  void loadRestaurantDetail(String id) async {
    state = ResultState.loading;
    notifyListeners();

    try {
      restaurantDetail = await restaurantService.fetchRestaurantDetail(id);
      isFavorite = await checkFavoriteStatus(id);
      state = ResultState.success;
    } catch (e) {
      state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> checkFavoriteStatus(String id) async {
    List<Map<String, dynamic>> result = await localStorageService
        .findByPrimaryKey(TableSchema.favorite, "id", id);
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void addToFavorite(Restaurant restaurant) async {
    Map<String, dynamic> objectMap = restaurant.toJson();

    localStorageService.insert(TableSchema.favorite, objectMap);

    isFavorite = true;
    notifyListeners();
  }

  void deleteFromFavorite(Restaurant restaurant) async {
    localStorageService.deleteWithPrimaryKey(
        TableSchema.favorite, "id", restaurant.id);

    isFavorite = false;
    notifyListeners();
  }
}
