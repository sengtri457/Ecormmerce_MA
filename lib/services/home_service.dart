import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/banner_item.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeService {
  const HomeService();

  static Future<String> loadString(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      try {
        final file = File(path);
        if (await file.exists()) {
          return await file.readAsString();
        }
      } catch (_) {}
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBannersData() async {
    final response = await loadString('assets/json/banners.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  Future<List<OnboardingItem>> getOnboardingItems() async {
    final data = await getBannersData();
    final list = data['onboarding'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => OnboardingItem.fromJson(e))
        .toList();
  }

  Future<List<CategoryItem>> getCategories() async {
    final response = await loadString('assets/json/categories.json');
    final list = json.decode(response) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => CategoryItem.fromJson(e))
        .toList();
  }

  Future<List<Product>> getProducts() async {
    final response = await loadString('assets/json/products.json');
    final list = json.decode(response) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => Product.fromJson(e))
        .toList();
  }

  Future<FeatureProduct> getFeatureProducts() async {
    final response = await loadString(
      'assets/json/feature_products.json',
    );
    final map = json.decode(response) as Map<String, dynamic>;
    return FeatureProduct.fromJson(map);
  }

  Future<List<VisualCategory>> getCategoryProducts() async {
    try {
      final rawData = await loadString('assets/json/categoryProducts.json');
      final list = json.decode(rawData) as List? ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => VisualCategory.fromJson(e))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<CategoryBannerItem>> getCategoryBanners() async {
    try {
      final response = await loadString('assets/json/category_banners.json');
      final list = json.decode(response) as List? ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => CategoryBannerItem.fromJson(e))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
