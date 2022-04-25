// To parse this JSON data, do
//
//     final subconstants = subconstantsFromJson(jsonString);

import 'dart:convert';

List<Subconstants> subconstantsFromJson(String str) => List<Subconstants>.from(json.decode(str).map((x) => Subconstants.fromJson(x)));

String subconstantsToJson(List<Subconstants> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subconstants {
    Subconstants({
        required this.index,
        required this.name,
        required this.brand,
        required this.url,
        required this.image,
    });

    int index;
    String name;
    String brand;
    String url;
    String image;

    factory Subconstants.fromJson(Map<String, dynamic> json) => Subconstants(
        index: json["index"],
        name: json["name"],
        brand: json["brand"],
        url: json["url"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "index": index,
        "name": name,
        "brand": brand,
        "url": url,
        "image": image,
    };
}
