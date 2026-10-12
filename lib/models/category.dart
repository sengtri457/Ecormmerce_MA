class Subcategory {
  final String id;
  final String name;
  final int count;
  final String? icon;

  Subcategory({
    required this.id,
    required this.name,
    required this.count,
    this.icon,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String?,
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final List<Subcategory> subcategories;

  CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.subcategories,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    final rawSub = json['subcategories'] as List? ?? const [];
    return CategoryItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      subcategories: rawSub
          .whereType<Map<String, dynamic>>()
          .map((s) => Subcategory.fromJson(s))
          .toList(),
    );
  }
}
