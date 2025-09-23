import 'package:flutter/material.dart';

/// Centralized asset paths
class AssetsManager {
  // Cart icons
  static const String shoppingCart = "assets/images/cart/shopping_cart.png";
  static const String shoppingBasket = "assets/images/cart/shopping_basket.png";

  // App logo
  static const String appLogo = "assets/images/logo/logo.png";

  // Fallback placeholder
  static const String fallbackImage = "assets/images/placeholder.png";

  // Banner images
  static const List<String> bannersImage = [
    "assets/images/banners/banner3.png",
    "assets/images/banners/banner4.png",
    "assets/images/banners/banner5.png",
  ];
}

/// Model for product categories
class CategoryModel {
  final String name;
  final String image;

  CategoryModel({required this.name, required this.image});
}

/// App constants for categories, safe asset helper, etc.
class AppConstants {
  // Categories list
  static final List<CategoryModel> CategoriesList = [
    CategoryModel(name: "Phones", image: "assets/images/categories/phones.png"),
    CategoryModel(name: "Fashion", image: "assets/images/categories/fashion.png"),
    CategoryModel(name: "Electronics", image: "assets/images/categories/electronics.png"),
    CategoryModel(name: "Books", image: "assets/images/categories/books.png"),
    CategoryModel(name: "Cosmetics", image: "assets/images/categories/cosmetics.png"),
  ];

  // ✅ Banner images shortcut
  static List<String> get banners => AssetsManager.bannersImage;

  // ✅ Safe asset helper: returns fallback if missing
  static String safeAsset(String? path) {
    if (path == null || path.trim().isEmpty) return AssetsManager.fallbackImage;
    return path;
  }

  // ✅ Categories dropdown helper (for Edit/Upload screen)
  static List<DropdownMenuItem<String>> get categoriesDropDownList {
    return CategoriesList.map((cat) {
      return DropdownMenuItem<String>(
        value: cat.name,
        child: Text(cat.name),
      );
    }).toList();
  }
}
