class ProductColor {
  final String name;
  final String hex;

  ProductColor({required this.name, required this.hex});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name'] as String,
      hex: json['hex'] as String,
    );
  }
}

class Product {
  final String id;
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
    var rawColors = json['colors'] as List? ?? [];
    var rawSizes = json['sizes'] as List? ?? [];
    var rawImages = json['images'] as List? ?? [];

    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPercent: json['discountPercent'] as int? ?? 0,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      isNew: json['isNew'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      material: json['material'] as String? ?? '',
      care: json['care'] as String? ?? '',
      colors: rawColors.map((c) => ProductColor.fromJson(c as Map<String, dynamic>)).toList(),
      sizes: rawSizes.map((s) => s.toString()).toList(),
      images: rawImages.map((i) => i.toString()).toList(),
    );
  }
}
