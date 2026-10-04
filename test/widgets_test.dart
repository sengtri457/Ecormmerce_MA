import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/screens/category/category_screen.dart';
import 'package:ecormmerce_ma/screens/home/widgets/department_tab_bar.dart';
import 'package:ecormmerce_ma/screens/home/widgets/home_section_header.dart';
import 'package:ecormmerce_ma/screens/bag/shopping_bag_screen.dart';
import 'package:ecormmerce_ma/screens/wishlist/wishlist_screen.dart';
import 'package:ecormmerce_ma/models/product.dart';
import 'package:ecormmerce_ma/screens/product/product_detail_screen.dart';
import 'package:ecormmerce_ma/widgets/trust_badges.dart';

void main() {
  group('Home Modular Widgets Tests', () {
    testWidgets('DepartmentTabBar renders all 5 department tabs and handles taps', (tester) async {
      String selected = 'women';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DepartmentTabBar(
              selectedDepartmentId: selected,
              onDepartmentSelected: (id) => selected = id,
            ),
          ),
        ),
      );

      expect(find.text('WOMEN'), findsOneWidget);
      expect(find.text('MEN'), findsOneWidget);
      expect(find.text('KIDS'), findsOneWidget);
      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('ACCESSORY'), findsOneWidget);

      await tester.tap(find.text('MEN'));
      await tester.pump();
      expect(selected, 'men');
    });

    testWidgets('HomeSectionHeader renders title and triggers action tap', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeSectionHeader(
              title: 'NEW IN WOMEN',
              actionText: 'SWIPE TO VIEW',
              onActionTap: () => actionTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('NEW IN WOMEN'), findsOneWidget);
      expect(find.text('SWIPE TO VIEW'), findsOneWidget);

      await tester.tap(find.text('SWIPE TO VIEW'));
      await tester.pump();
      expect(actionTapped, true);
    });

    testWidgets('TrustBadges renders 3 guarantee columns', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TrustBadges(),
          ),
        ),
      );

      expect(find.text('GLOBAL SHIPPING'), findsOneWidget);
      expect(find.text('14-DAY RETURN'), findsOneWidget);
      expect(find.text('SECURE PAYMENT'), findsOneWidget);
    });

    testWidgets('CategoryScreen renders category cards, accordions and switches grid/list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryScreen(),
          ),
        ),
      );

      // Verify category title and cards
      expect(find.text('CATEGORY'), findsOneWidget);
      expect(find.text('THE MINIMAL WARDROBE EDIT'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);

      // Verify toggle button interaction
      await tester.tap(find.byIcon(Icons.grid_view_sharp));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.crop_16_9_outlined));
      await tester.pump();
    });

    testWidgets('WishlistScreen renders Wishlist header, back button, and Go to Bag actions', (tester) async {
      bool bagTapped = false;
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: WishlistScreen(
            onNavigateToBag: () => bagTapped = true,
            onBack: () => backTapped = true,
          ),
        ),
      );

      expect(find.text('WISH LIST'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      expect(backTapped, true);

      await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
      expect(bagTapped, true);
    });

    testWidgets('ShoppingBagScreen renders bag header, back button, and wishlist navigation', (tester) async {
      bool wishlistTapped = false;
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ShoppingBagScreen(
            onNavigateToWishlist: () => wishlistTapped = true,
            onBack: () => backTapped = true,
          ),
        ),
      );

      expect(find.text('SHOPPING BAG'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      expect(backTapped, true);

      await tester.tap(find.byIcon(Icons.favorite_border));
      expect(wishlistTapped, true);
    });

    testWidgets('ProductDetailScreen renders modular sections and handles Add to Bag', (tester) async {
      final sampleProduct = Product(
        id: 'test_p1',
        title: 'Structured Oversized Wool Blazer',
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
        description: 'Tailored virgin wool blazer.',
        material: '100% Virgin Wool.',
        care: 'Specialist dry clean.',
        colors: [ProductColor(name: 'Noir', hex: '#1E1E1E')],
        sizes: ['S', 'M', 'L'],
        images: ['assets/images/bannerMen.gif'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: sampleProduct),
        ),
      );

      // Verify gallery, header info, size selector, and bottom bar
      expect(find.text('MA STUDIO'), findsWidgets);
      expect(find.text('ADD TO BAG'), findsOneWidget);
      expect(find.text('THE DETAIL'), findsOneWidget);
      expect(find.text('SIZE & FITS'), findsOneWidget);

      // Tap Add to Bag
      await tester.tap(find.text('ADD TO BAG'));
      await tester.pump();
    });
  });
}
