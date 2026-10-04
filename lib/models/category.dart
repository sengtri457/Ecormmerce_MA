class Subcategory {
  final String id;
  final String name;
  final int count;

  Subcategory({
    required this.id,
    required this.name,
    required this.count,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] as String,
      name: json['name'] as String,
      count: json['count'] as int,
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
    var rawSub = json['subcategories'] as List? ?? [];
    return CategoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['imageUrl'] as String,
      subcategories: rawSub.map((s) => Subcategory.fromJson(s as Map<String, dynamic>)).toList(),
    );
  }
}
