import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/service/local_storage_service.dart';
import 'package:flutter/foundation.dart';

enum ResultState { loading, success, empty, error }

class FavoriteProvider extends ChangeNotifier {

  final LocalStorageService localStorageService;

  late ResultState state = ResultState.loading;
  late List<Restaurant> restaurants = [];

  FavoriteProvider({
    required this.localStorageService
  }) {
    loadData();
  }

  void loadData() async {
    state = ResultState.loading;
    notifyListeners();

    try {
      List<Map<String, dynamic>> dbResult = await localStorageService.find(TableSchema.favorite);
      restaurants = List<Restaurant>.from(dbResult.map((x) => Restaurant.fromJson(x)));
      if (restaurants.isEmpty) {
        state = ResultState.empty;
      } else {
        state = ResultState.success;
      }
    } catch(e) {
      state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }

  void findData(String query) async {
    if (query.isEmpty) {
      loadData();
      return;
    }

    state = ResultState.loading;
    notifyListeners();

    try {
      List<Map<String, dynamic>> dbResult = await localStorageService.findByColumn(TableSchema.favorite, "name", query);
      restaurants = List<Restaurant>.from(dbResult.map((x) => Restaurant.fromJson(x)));
      if (restaurants.isEmpty) {
        state = ResultState.empty;
      } else {
        state = ResultState.success;
      }
    } catch(e) {
      state = ResultState.error;
    } finally {
      notifyListeners();
    }
  }
}