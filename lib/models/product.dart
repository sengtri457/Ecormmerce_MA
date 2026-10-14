class ProductColor {
  final String name;
  final String hex;

  ProductColor({required this.name, required this.hex});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name'] as String? ?? '',
      hex: json['hex'] as String? ?? '#000000',
    );
  }
}

class Product {
  final int id;
  final String title;
  final String brand;
  final String category;
  final String subcategory;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final bool isNew;
  final bool isFeatured;
  final String description;
  final String material;
  final String care;
  final List<ProductColor> colors;
  final List<String> sizes;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.isNew,
    required this.isFeatured,
    required this.description,
    required this.material,
    required this.care,
    required this.colors,
    required this.sizes,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawColors = json['colors'] as List? ?? const [];
    final rawSizes = json['sizes'] as List? ?? const [];
    final rawImages = json['images'] as List? ?? const [];

    return Product(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subcategory: json['subcategory'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isNew: json['isNew'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      material: json['material'] as String? ?? '',
      care: json['care'] as String? ?? '',
      colors: rawColors
          .whereType<Map<String, dynamic>>()
          .map((c) => ProductColor.fromJson(c))
          .toList(),
      sizes: rawSizes.map((s) => s.toString()).toList(),
      images: rawImages.map((i) => i.toString()).toList(),
    );
  }
}

class FeatureProduct {
  final String exclusiveOffersTitle;
  final String bestSellingsTitle;
  final String featuresTitle;
  final List<Product> exclusiveOffers;
  final List<Product> bestSellings;
  final List<Product> features;

  const FeatureProduct({
    this.exclusiveOffersTitle = 'EXCLUSIVE OFFERS',
    this.bestSellingsTitle = 'BEST SELLING',
    this.featuresTitle = 'EXPLORE CATEGORIES',
    this.exclusiveOffers = const [],
    this.bestSellings = const [],
    this.features = const [],
  });

  String get newArrivalsTitle => exclusiveOffersTitle;
  String get trendingTitle => bestSellingsTitle;
  String get categoriesTitle => featuresTitle;

  factory FeatureProduct.fromJson(Map<String, dynamic> json) {
    return FeatureProduct(
      exclusiveOffersTitle:
          json['exclusive_offers_title'] as String? ??
          json['new_arrivals_title'] as String? ??
          'EXCLUSIVE OFFERS',
      bestSellingsTitle:
          json['best_sellings_title'] as String? ??
          json['trending_title'] as String? ??
          'BEST SELLING',
      featuresTitle:
          json['features_title'] as String? ??
          json['categories_title'] as String? ??
          'EXPLORE CATEGORIES',
      exclusiveOffers: (json['exclusive_offers'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
      bestSellings: (json['best_sellings'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
      features: (json['features'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
