/// Clean, centralized price formatting helper.
/// Replaces repetitive inline price formatting logic across the application.
class CurrencyHelper {
  CurrencyHelper._();

  /// Formats a numeric price into a currency string.
  /// If the number is an exact integer, it displays without decimals (e.g. $160).
  /// If it has cents, it shows 2 decimal places (e.g. $160.50).
  static String format(num price) {
    if (price == price.toInt()) {
      return '\$${price.toInt()}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Formats a discount amount with a negative sign (e.g. -$50.00 or -$50).
  static String formatDiscount(num discount) {
    if (discount == 0) return '\$0';
    if (discount == discount.toInt()) {
      return '-\$${discount.toInt()}';
    }
    return '-\$${discount.toStringAsFixed(2)}';
  }
}

/// Convenience extension on [num] for clean, readable syntax: `product.price.toCurrency()`.
extension CurrencyExtension on num {
  String toCurrency() => CurrencyHelper.format(this);
  String toDiscountCurrency() => CurrencyHelper.formatDiscount(this);
}
