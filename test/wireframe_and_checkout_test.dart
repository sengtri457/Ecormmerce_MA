import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/screens/profile/user_profile_screen.dart';
import 'package:ecormmerce_ma/services/mock_data_service.dart';
import 'package:ecormmerce_ma/widgets/app_wireframe.dart';

void main() {
  group('MockDataService Auth Guard', () {
    test('login and logout state transitions correctly', () {
      final service = MockDataService();
      expect(service.isLoggedIn, isFalse);

      service.login();
      expect(service.isLoggedIn, isTrue);

      service.logout();
      expect(service.isLoggedIn, isFalse);
    });
  });

  group('UserProfileScreen Auth Guarding', () {
    testWidgets('shows simple login prompt when user is not logged in', (tester) async {
      MockDataService().logout();

      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(),
        ),
      );

      expect(find.text('SIGN IN REQUIRED'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('PERSONAL INFORMATION'), findsNothing);
    });

    testWidgets('shows full profile when user is logged in', (tester) async {
      MockDataService().login();

      await tester.pumpWidget(
        const MaterialApp(
          home: UserProfileScreen(),
        ),
      );

      expect(find.text('SIGN IN REQUIRED'), findsNothing);
      expect(find.text('LOG OUT'), findsOneWidget);

      // Clean up back to guest for other tests
      MockDataService().logout();
    });
  });

  group('AppWireframe Widgets', () {
    testWidgets('AppWireframe components render without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppWireframe.box(width: 100, height: 100),
                  AppWireframe.circle(size: 50),
                  AppWireframe.text(width: 120),
                  AppWireframe.heroBanner(height: 150),
                  AppWireframe.categoryPills(count: 3),
                  AppWireframe.productCard(width: 140),
                  AppWireframe.listTile(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AppWireframe), findsWidgets);
    });
  });
}
