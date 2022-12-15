import 'dart:convert';

class MenuDetail {
  String name;

  MenuDetail({
    required this.name
  });

  factory MenuDetail.fromRawJson(String str) => MenuDetail.fromRawJson(str);

  String toRawJson() => json.encode(toJson());

  factory MenuDetail.fromJson(Map<String, dynamic> json) => MenuDetail(
      name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name
  };
}