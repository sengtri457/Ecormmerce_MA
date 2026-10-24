import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/banner_item.dart';
import '../models/category_item.dart';
import '../models/department_taxonomy.dart';
import '../models/product.dart';

class HomeService {
  const HomeService();
  static Future<String> loadString(String path) async {
    return rootBundle.loadString(path);
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

  Future<List<DepartmentTaxonomy>> getTaxonomy() async {
    final response = await loadString('assets/json/categories.json');
    final list = json.decode(response) as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => DepartmentTaxonomy.fromJson(e))
        .toList();
  }

  Future<List<CategoryItem>> getCategories() async {
    final taxonomies = await getTaxonomy();
    return taxonomies.expand((t) => t.categories).toList();
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
    final response = await loadString('assets/json/feature_products.json');
    final map = json.decode(response) as Map<String, dynamic>;
    return FeatureProduct.fromJson(map);
  }

  Future<List<CategoryBannerItem>> getCategoryBanners() async {
    return const [
      CategoryBannerItem(
        id: 'accessories',
        title: 'ACCESSORIES',
        imagePath: 'assets/images/category/banner1.jpg',
        slug: 'accessories',
      ),
      CategoryBannerItem(
        id: 'clothing',
        title: 'CLOTHING',
        imagePath: 'assets/images/category/banner3.jpg',
        slug: 'clothing',
      ),
      CategoryBannerItem(
        id: 'shoes',
        title: 'SHOES',
        imagePath: 'assets/images/category/banner2.jpg',
        slug: 'shoes',
      ),
    ];
  }
}
