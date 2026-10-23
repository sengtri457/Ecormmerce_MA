import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EcormmerceApp());
    expect(find.byType(EcormmerceApp), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();
  });
}
