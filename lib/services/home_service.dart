import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/banner_item.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeService {
  const HomeService();

  Future<Map<String, dynamic>> getBannersData() async {
    final response = await rootBundle.loadString('assets/json/banners.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  /// Loads onboarding items
  Future<List<OnboardingItem>> getOnboardingItems() async {
    final data = await getBannersData();
    final list = data['onboarding'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => OnboardingItem.fromJson(e))
        .toList();
  }

  /// Loads hero carousel slides
  Future<List<HomeBannerItem>> getHeroBanners() async {
    final data = await getBannersData();
    final list = data['home_hero_banners'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => HomeBannerItem.fromJson(e))
        .toList();
  }

  /// Loads promotional promo drops
  Future<List<PromoOffer>> getPromoOffers() async {
    final data = await getBannersData();
    final list = data['promo_offers'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => PromoOffer.fromJson(e))
        .toList();
  }

  /// Loads all store categories with nested subcategories
  Future<List<CategoryItem>> getCategories() async {
    final response = await rootBundle.loadString('assets/json/categories.json');
    final list = json.decode(response) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => CategoryItem.fromJson(e))
        .toList();
  }

  /// Loads all catalog products
  Future<List<Product>> getProducts() async {
    final response = await rootBundle.loadString('assets/json/products.json');
    final list = json.decode(response) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => Product.fromJson(e))
        .toList();
  }

  Future<FeatureProduct> getFeatureProducts() async {
    final response = await rootBundle.loadString(
      'assets/json/feature_products.json',
    );
    final map = json.decode(response) as Map<String, dynamic>;
    return FeatureProduct.fromJson(map);
  }

  /// Loads visual category cards and accordion groups from categoryProducts.json
  Future<List<VisualCategory>> getCategoryProducts() async {
    String? rawData;
    try {
      rawData = await rootBundle.loadString('assets/json/categoryProducts.json');
    } catch (_) {
      try {
        rawData = await rootBundle.loadString('assets/json/categoryProducs.json');
      } catch (_) {
        return const [];
      }
    }
    final list = json.decode(rawData) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => VisualCategory.fromJson(e))
        .toList();
  }
}
