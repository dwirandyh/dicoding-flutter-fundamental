import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart';
import 'package:flutter/foundation.dart';

enum ResultState { loading, success, empty, error }

class HomeProvider extends ChangeNotifier {
  final RestaurantService restaurantService;

  late ResultState state = ResultState.loading;
  late List<Restaurant> restaurants = [];

  HomeProvider({required this.restaurantService}) {
    loadData();
  }

  Future<void> loadData() async {
    state = ResultState.loading;
    notifyListeners();

    try {
      restaurants = await restaurantService.fetchAllRestaurant();
      if (restaurants.isEmpty) {
        state = ResultState.empty;
      } else {
        state = ResultState.success;
      }
    } catch (e) {
      state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> findData(String query) async {
    if (query.isEmpty) {
      loadData();
      return;
    }

    state = ResultState.loading;
    notifyListeners();

    try {
      restaurants = await restaurantService.findRestaurant(query);
      if (restaurants.isEmpty) {
        state = ResultState.empty;
      } else {
        state = ResultState.success;
      }
    } catch (e) {
      state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }
}
