import '../models/product.dart';

class CatalogFilterHelper {
  CatalogFilterHelper._();

  static bool matchesPillar(Product product, String pillar) {
    final sub = product.subcategory.toLowerCase();
    final title = product.title.toLowerCase();
    final target = pillar.toLowerCase();

    if (target == 'clothes' || target == 'clothing') {
      return sub.contains('coat') ||
          sub.contains('dress') ||
          sub.contains('top') ||
          sub.contains('shirt') ||
          sub.contains('jacket') ||
          sub.contains('suit') ||
          sub.contains('pant') ||
          sub.contains('hoodie') ||
          sub.contains('knit') ||
          sub.contains('boy') ||
          sub.contains('girl');
    } else if (target == 'shoes') {
      return sub.contains('shoe') ||
          sub.contains('footwear') ||
          title.contains('shoe') ||
          title.contains('boot') ||
          title.contains('sneaker') ||
          title.contains('derby');
    } else if (target == 'accessories') {
      return sub.contains('bag') ||
          sub.contains('leather') ||
          sub.contains('accessory') ||
          sub.contains('hat') ||
          sub.contains('belt') ||
          title.contains('bag') ||
          title.contains('candle');
    }
    return true;
  }
}
