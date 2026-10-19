import 'category_item.dart';

class DepartmentTaxonomy {
  final String id;
  final String name;
  final String slug;
  final List<CategoryItem> categories;

  const DepartmentTaxonomy({
    required this.id,
    required this.name,
    required this.slug,
    required this.categories,
  });

  factory DepartmentTaxonomy.fromJson(Map<String, dynamic> json) {
    final deptId = json['department'] as String? ?? json['id'] as String? ?? '';
    final rawCats =
        (json['categories'] ?? json['subcategories']) as List? ?? const [];

    return DepartmentTaxonomy(
      id: deptId,
      name: json['name'] as String? ?? deptId.toUpperCase(),
      slug: json['slug'] as String? ?? deptId,
      categories: rawCats
          .whereType<Map<String, dynamic>>()
          .map((c) => CategoryItem.fromJson(c, department: deptId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'categories': categories.map((c) => c.toJson()).toList(),
  };
}
