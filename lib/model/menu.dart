import 'dart:convert';
import 'package:dicoding_flutter_fundamental/model/menu_detail.dart';

class Menu {
  List<MenuDetail> foods;
  List<MenuDetail> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromRawJson(String str) => Menu.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      foods: List<MenuDetail>.from(
          json["foods"].map((x) => MenuDetail.fromJson(x))),
      drinks: List<MenuDetail>.from(
          json["drinks"].map((x) => MenuDetail.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((e) => e.toJson())),
        "drinks": List<dynamic>.from(drinks.map((e) => e.toJson())),
      };
}
