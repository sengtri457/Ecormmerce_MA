import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/models/product.dart';

void main() {
  group('FeatureProduct Title Binding Tests', () {
    test('defaults to standard section titles when not specified in JSON', () {
      final fp = FeatureProduct.fromJson(const {});

      expect(fp.exclusiveOffersTitle, 'EXCLUSIVE OFFERS');
      expect(fp.bestSellingsTitle, 'BEST SELLING');
      expect(fp.featuresTitle, 'EXPLORE CATEGORIES');

      expect(fp.newArrivalsTitle, 'EXCLUSIVE OFFERS');
      expect(fp.trendingTitle, 'BEST SELLING');
      expect(fp.categoriesTitle, 'EXPLORE CATEGORIES');
    });

    test('binds custom titles from JSON when provided', () {
      final json = {
        'exclusive_offers_title': 'EXCLUSIVE DROP DEALS',
        'best_sellings_title': 'TOP BESTSELLERS',
        'features_title': 'BROWSE ALL CATEGORIES',
      };

      final fp = FeatureProduct.fromJson(json);

      expect(fp.exclusiveOffersTitle, 'EXCLUSIVE DROP DEALS');
      expect(fp.bestSellingsTitle, 'TOP BESTSELLERS');
      expect(fp.featuresTitle, 'BROWSE ALL CATEGORIES');

      expect(fp.newArrivalsTitle, 'EXCLUSIVE DROP DEALS');
      expect(fp.trendingTitle, 'TOP BESTSELLERS');
      expect(fp.categoriesTitle, 'BROWSE ALL CATEGORIES');
    });

    test('supports alternate snake_case title keys from JSON', () {
      final json = {
        'new_arrivals_title': 'NEW IN STORE NOW',
        'trending_title': 'TRENDING NOW',
        'categories_title': 'DISCOVER CATEGORIES',
      };

      final fp = FeatureProduct.fromJson(json);

      expect(fp.newArrivalsTitle, 'NEW IN STORE NOW');
      expect(fp.trendingTitle, 'TRENDING NOW');
      expect(fp.categoriesTitle, 'DISCOVER CATEGORIES');
    });
  });
}
