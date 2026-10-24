import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/screens/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo and progress bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.text('MA STUDIO'), findsOneWidget);
    expect(find.text('CURATED FASHION & LIFESTYLE'), findsOneWidget);
    expect(find.text('LOADING COLLECTION'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(FractionallySizedBox), findsWidgets);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
  });
}
