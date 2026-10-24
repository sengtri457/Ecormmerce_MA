import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/models/product.dart';
import 'package:ecormmerce_ma/screens/product/widgets/product_header_info.dart';
import 'package:ecormmerce_ma/services/mock_data_service.dart';
import 'package:ecormmerce_ma/widgets/app_image.dart';
import 'package:ecormmerce_ma/widgets/app_rating_stars.dart';
import 'package:ecormmerce_ma/widgets/product_card.dart';

void main() {
  group('Rating Feature Tests', () {
    test('MockDataService.rateProduct calculates new average and updates count', () {
      final service = MockDataService();
      
      // Seed a test product
      final initialProduct = Product(
        id: 9999,
        title: 'Rating Test Jacket',
        brand: 'MA Studio',
        category: 'men',
        subcategory: 'jackets',
        price: 200.0,
        originalPrice: 200.0,
        discountPercent: 0,
        rating: 4.0,
        reviewCount: 4, // Total score = 16.0
        isNew: true,
        isFeatured: false,
        description: 'Test jacket',
        material: 'Wool',
        care: 'Dry clean',
        colors: [],
        sizes: ['M', 'L'],
        images: [],
      );

      service.products.add(initialProduct);

      // User submits rating of 5.0
      // (16.0 + 5.0) / 5 = 21.0 / 5 = 4.2
      service.rateProduct(9999, 5.0);

      final updated = service.getProductById(9999);
      expect(updated, isNotNull);
      expect(updated!.rating, 4.2);
      expect(updated.reviewCount, 5);
      expect(updated.userRating, 5.0);

      // User changes their rating from 5.0 to 3.0
      // Previous total without user rating = 21.0 - 5.0 = 16.0
      // New total = 16.0 + 3.0 = 19.0 / 5 = 3.8
      service.rateProduct(9999, 3.0);

      final reupdated = service.getProductById(9999);
      expect(reupdated!.rating, 3.8);
      expect(reupdated.reviewCount, 5); // Count remains 5
      expect(reupdated.userRating, 3.0);

      // Clean up test product
      service.products.removeWhere((p) => p.id == 9999);
    });

    testWidgets('AppRatingStars.compact displays rating score and review count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppRatingStars.compact(
              rating: 4.8,
              reviewCount: 120,
            ),
          ),
        ),
      );

      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(120)'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('AppRatingStars full 5-star view displays all 5 stars and handles interactive taps', (tester) async {
      double selectedRating = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRatingStars.interactive(
              rating: 3.0,
              onRatingChanged: (val) => selectedRating = val,
            ),
          ),
        ),
      );

      // Expect 5 star icons
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));

      // Tap 5th star
      await tester.tap(find.byIcon(Icons.star_rounded).last);
      await tester.pump();

      expect(selectedRating, 5.0);
    });

    testWidgets('ProductCard displays AppRatingStars and updates reactively when rated', (tester) async {
      final service = MockDataService();
      final sampleProduct = Product(
        id: 7777,
        title: 'Linen Overshirt',
        brand: 'MA STUDIO',
        category: 'women',
        subcategory: 'shirts',
        price: 150.0,
        originalPrice: 150.0,
        discountPercent: 0,
        rating: 4.0,
        reviewCount: 10,
        isNew: false,
        isFeatured: false,
        description: 'Test item',
        material: 'Linen',
        care: 'Hand wash',
        colors: [],
        sizes: ['S', 'M'],
        images: [],
      );

      service.products.add(sampleProduct);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 350,
              width: 200,
              child: ProductCard(product: sampleProduct),
            ),
          ),
        ),
      );

      expect(find.text('4.0'), findsOneWidget);
      expect(find.text('(10)'), findsOneWidget);

      // Rate the product
      service.rateProduct(7777, 5.0);
      await tester.pump();

      // displayRating is liveProduct.userRating ?? liveProduct.rating = 5.0
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('(11)'), findsOneWidget);

      service.products.removeWhere((p) => p.id == 7777);
    });

    testWidgets('ProductHeaderInfo displays user rating on the stars when user has rated', (tester) async {
      final sampleProduct = Product(
        id: 6666,
        title: 'Silk Scarf',
        brand: 'MA STUDIO',
        category: 'women',
        subcategory: 'scarves',
        price: 80.0,
        originalPrice: 80.0,
        discountPercent: 0,
        rating: 4.8,
        reviewCount: 20,
        userRating: 2.0,
        isNew: false,
        isFeatured: false,
        description: 'Luxury scarf',
        material: 'Silk',
        care: 'Dry clean',
        colors: [],
        sizes: ['One Size'],
        images: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductHeaderInfo(product: sampleProduct),
          ),
        ),
      );

      // The star icons display 2.0 and review count (20 reviews)
      expect(find.text('2.0'), findsOneWidget);
      expect(find.text('(20 reviews)'), findsOneWidget);
    });

    testWidgets('ProductCard keeps its original image untouched when rated', (tester) async {
      final service = MockDataService();
      final blazerProduct = Product(
        id: 5555,
        title: 'Structured Wool Blazer',
        brand: 'MA STUDIO',
        category: 'women',
        subcategory: 'w_coats',
        price: 289.0,
        originalPrice: 385.0,
        discountPercent: 25,
        rating: 4.9,
        reviewCount: 128,
        isNew: true,
        isFeatured: true,
        description: 'Tailored blazer',
        material: 'Virgin Wool',
        care: 'Dry clean',
        colors: [],
        sizes: ['M'],
        images: ['assets/images/products/product1.jpg'],
      );

      service.products.add(blazerProduct);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 350,
              width: 200,
              child: ProductCard(product: blazerProduct),
            ),
          ),
        ),
      );

      // Verify the image rendered uses assets/images/products/product1.jpg
      final appImageFinder = find.byType(AppImage);
      expect(appImageFinder, findsOneWidget);
      AppImage appImage = tester.widget(appImageFinder);
      expect(appImage.imagePath, 'assets/images/products/product1.jpg');

      // Now rate the product
      service.rateProduct(5555, 3.0);
      await tester.pump();

      // Verify rating changed to 3.0
      expect(find.text('3.0'), findsOneWidget);
      expect(find.text('(129)'), findsOneWidget);

      // Verify image path is STILL assets/images/products/product1.jpg and NEVER changed!
      appImage = tester.widget(appImageFinder);
      expect(appImage.imagePath, 'assets/images/products/product1.jpg');

      service.products.removeWhere((p) => p.id == 5555);
    });
  });
}
