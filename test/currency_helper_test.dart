import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/helpers/currency_helper.dart';

void main() {
  group('CurrencyHelper Tests', () {
    test('formats whole numbers without decimal places', () {
      expect(CurrencyHelper.format(160), '\$160');
      expect(CurrencyHelper.format(160.0), '\$160');
      expect(CurrencyHelper.format(0), '\$0');
    });

    test('formats fractional numbers with two decimal places', () {
      expect(CurrencyHelper.format(160.50), '\$160.50');
      expect(CurrencyHelper.format(160.99), '\$160.99');
      expect(CurrencyHelper.format(15.2), '\$15.20');
    });

    test('formats discount amounts with negative sign', () {
      expect(CurrencyHelper.formatDiscount(50), '-\$50');
      expect(CurrencyHelper.formatDiscount(50.0), '-\$50');
      expect(CurrencyHelper.formatDiscount(50.25), '-\$50.25');
      expect(CurrencyHelper.formatDiscount(0), '\$0');
    });

    test('CurrencyExtension works seamlessly on num', () {
      expect(160.toCurrency(), '\$160');
      expect(289.5.toCurrency(), '\$289.50');
      expect(50.toDiscountCurrency(), '-\$50');
    });
  });
}
