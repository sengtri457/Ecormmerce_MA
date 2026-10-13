import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ecormmerce_ma/models/cart_item.dart';
import 'package:ecormmerce_ma/services/mock_data_service.dart';
import 'package:ecormmerce_ma/screens/bag/shopping_bag_screen.dart';

void main() {
  group('Shopping Bag Selection & Calculation Logic Tests', () {
    late MockDataService service;

    setUp(() {
      service = MockDataService();
      // Configure test cart items
      service.cartItems = [
        CartItem(
          id: 'test_1',
          productId: 1,
          title: 'Radical Graphic Oversized T-Shirt',
          brand: 'MA STUDIO',
          price: 45.0,
          originalPrice: 65.0,
          color: 'Black',
          size: 'S',
          quantity: 2, // Total $90
          imageUrl: 'assets/images/products/image1.jpg',
          isSelected: true,
        ),
        CartItem(
          id: 'test_2',
          productId: 2,
          title: 'Structured Oversized Wool Blazer',
          brand: 'MA STUDIO',
          price: 289.0,
          originalPrice: 350.0,
          color: 'Noir',
          size: 'XS',
          quantity: 1, // Total $289
          imageUrl: 'assets/images/products/image2.jpg',
          isSelected: true,
        ),
      ];
      service.discountAmount = 20.0;
      service.shippingFee = 15.0;
      service.promoCode = 'FIRST20';
    });

    test('Both items selected calculates full total', () {
      expect(service.selectedCartCount, 2);
      expect(service.isAllCartSelected, true);
      // 90 + 289 = 379
      expect(service.cartSubtotal, 379.0);
      expect(service.effectiveShippingFee, 15.0);
      expect(service.effectiveDiscountAmount, 20.0);
      // 379 + 15 - 20 = 374
      expect(service.cartTotal, 374.0);
    });

    test('Unselecting one item recalculates subtotal and total for only selected item', () {
      // Unselect item 2 ($289)
      service.toggleCartItemSelection('test_2', false);

      expect(service.selectedCartCount, 1);
      expect(service.isAllCartSelected, false);
      // Only item 1: 45 * 2 = $90
      expect(service.cartSubtotal, 90.0);
      expect(service.effectiveShippingFee, 15.0);
      expect(service.effectiveDiscountAmount, 20.0);
      // 90 + 15 - 20 = 85
      expect(service.cartTotal, 85.0);
    });

    test('Unselecting all items sets subtotal, shipping fee, and total to 0', () {
      service.selectAllCartItems(false);

      expect(service.selectedCartCount, 0);
      expect(service.isAllCartSelected, false);
      expect(service.cartSubtotal, 0.0);
      expect(service.effectiveShippingFee, 0.0);
      expect(service.effectiveDiscountAmount, 0.0);
      expect(service.cartTotal, 0.0);
    });

    test('Selecting all items restores full selection', () {
      service.selectAllCartItems(false);
      expect(service.selectedCartCount, 0);

      service.selectAllCartItems(true);
      expect(service.selectedCartCount, 2);
      expect(service.cartSubtotal, 379.0);
    });

    testWidgets('ShoppingBagScreen displays correct calculations when toggling checkboxes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShoppingBagScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially both items are selected
      expect(find.text('Sub-Total'), findsOneWidget);
      expect(find.text('\$379'), findsOneWidget);
      expect(find.text('PROCEED TO CHECKOUT • \$374'), findsOneWidget);

      // Find the checkboxes (Icons.check)
      // Top "SELECT ALL" has 1 icon, Item 1 has 1 icon, Item 2 has 1 icon -> total 3 check icons
      expect(find.byIcon(Icons.check), findsNWidgets(3));

      // Toggle item 2 to unselect
      service.toggleCartItemSelection('test_2', false);
      await tester.pumpAndSettle();

      // Subtotal should now be $90 and total $85
      expect(find.text('\$90'), findsWidgets);
      expect(find.text('PROCEED TO CHECKOUT • \$85'), findsOneWidget);
      expect(find.text('1 OF 2 SELECTED'), findsOneWidget);

      // Unselect all items
      service.selectAllCartItems(false);
      await tester.pumpAndSettle();

      expect(find.text('0 OF 2 SELECTED'), findsOneWidget);
      expect(find.text('SELECT ITEMS TO CHECKOUT'), findsOneWidget);
      expect(find.text('\$0'), findsWidgets);
    });
  });
}
