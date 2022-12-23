import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_detail.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<List<Restaurant>> fetchAllRestaurant() async {
    const String url = "$_baseUrl/list";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body)).restaurants;
    } else {
      throw Exception("Gagal mengambil data restaurant");
    }
  }

  Future<List<Restaurant>> findRestaurant(String query) async {
    String url = "$_baseUrl/search?q=$query";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body)).restaurants;
    } else {
      throw Exception("Gagal mengambil data restaurant");
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    String url = "$_baseUrl/detail/$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(
          json.decode(response.body)["restaurant"]);
    } else {
      throw Exception("Gagal mengambil data restaurant");
    }
  }
}
