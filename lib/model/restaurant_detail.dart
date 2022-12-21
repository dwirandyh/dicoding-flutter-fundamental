import 'dart:convert';

import 'package:dicoding_flutter_fundamental/model/menu.dart';

class RestaurantDetail {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menu menu;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menu,
  });

  factory RestaurantDetail.fromRawJson(String str) => RestaurantDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) => RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: double.tryParse(json["rating"].toString()) ?? 0,
      menu: Menu.fromJson(json["menus"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
    "menus": menu.toJson()
  };
}






















