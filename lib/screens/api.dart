import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<Shoes>> shoes(BuildContext context) async {
  final assetBundle = DefaultAssetBundle.of(context);
  final data = await assetBundle.loadString('assets/shoes.json');
  final body = json.decode(data);
  return body.map<Shoes>(Shoes.fromJson).toList();
}

Future<Brands> brands(BuildContext context) async {
  final assetBundle = DefaultAssetBundle.of(context);
  final data = await assetBundle.loadString('assets/brands.json');
  final body = json.decode(data);
  return Brands.fromJson(body);
}

Future<Sizes> sizes(BuildContext context) async {
  final assetBundle = DefaultAssetBundle.of(context);
  final data = await assetBundle.loadString('assets/sizes.json');
  final body = json.decode(data);
  return Sizes.fromJson(body);
}

class Sizes {
  final List<int> sizes;

  const Sizes({required this.sizes});

  factory Sizes.fromJson(Map<String, dynamic> json) {
    List<int> sizes = json['sizes'].cast<int>();
    return Sizes(sizes: sizes);
  }
}

class Brands {
  final List<String> brands;

  const Brands({required this.brands});

  factory Brands.fromJson(json) {
    List<String> brands = json["brands"].cast<String>();
    return Brands(brands: brands);
  }
}

class Shoes {
  final String name;
  final String brand;
  final String color;
  final String category;
  final int price;
  final Images image;

  const Shoes({
    required this.name,
    required this.brand,
    required this.color,
    required this.category,
    required this.price,
    required this.image,
  });

  factory Shoes.fromJson(json) {
    return Shoes(
      name: json['name'],
      brand: json['brand'],
      color: json['color'],
      category: json['category'],
      price: json['price'],
      image: Images.fromJson(json['image']),
    );
  }
}

class Images {
  final String thumbnail;
  final List<String> images;

  const Images({required this.thumbnail, required this.images});

  factory Images.fromJson(json) {
    var image = json['images'];
    List<String> images = image.cast<String>();
    return Images(images: images, thumbnail: json['thumbnail']);
  }
}
