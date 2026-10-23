class CurrencyHelper {
  CurrencyHelper._();
  static String format(num price) {
    if (price == price.toInt()) {
      return '\$${price.toInt()}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  /// negative discount formatting helper.
  static String formatDiscount(num discount) {
    if (discount == 0) return '\$0';
    if (discount == discount.toInt()) {
      return '-\$${discount.toInt()}';
    }
    return '-\$${discount.toStringAsFixed(2)}';
  }
}

extension CurrencyExtension on num {
  String toCurrency() => CurrencyHelper.format(this);
  String toDiscountCurrency() => CurrencyHelper.formatDiscount(this);
}
