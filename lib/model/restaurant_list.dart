import 'dart:convert';
import 'restaurant.dart';

class RestaurantList {

  List<Restaurant> restaurants;

  RestaurantList({
    required this.restaurants
  });

  factory RestaurantList.fromRawJson(String str) => RestaurantList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x)))
  );

  Map<String, dynamic> toJson() => {
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}