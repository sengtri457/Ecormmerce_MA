import 'subcategory.dart';
export 'subcategory.dart';

class CategoryItem {
  final String id;
  final String department;
  final String name;
  final String slug;
  final String icon;
  final String image;
  final String fallback;
  final int itemCount;
  final List<Subcategory> subcategories;

  const CategoryItem({
    required this.id,
    this.department = 'women',
    required this.name,
    this.slug = '',
    this.icon = '',
    this.image = '',
    this.fallback = '',
    this.itemCount = 0,
    required this.subcategories,
  });

  String get title => name.toUpperCase();

  String get imageUrl => image;

  List<String> get subcategoryNames =>
      subcategories.map((s) => s.name).toList();

  factory CategoryItem.fromJson(
    Map<String, dynamic> json, {
    String department = 'women',
  }) {
    final rawSub = json['subcategories'] as List? ?? const [];

    return CategoryItem(
      id: json['id'] as String? ?? '',
      department: json['department'] as String? ?? department,
      name: json['name'] as String? ?? json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? json['id'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      image: json['image'] as String? ?? json['imageUrl'] as String? ?? '',
      fallback:
          json['fallback'] as String? ?? json['fallbackUrl'] as String? ?? '',
      itemCount: (json['itemCount'] ?? json['count'] as num?)?.toInt() ?? 0,
      subcategories: rawSub
          .whereType<Map<String, dynamic>>()
          .map((s) => Subcategory.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'department': department,
    'name': name,
    'slug': slug,
    'icon': icon,
    'image': image,
    'fallback': fallback,
    'itemCount': itemCount,
    'subcategories': subcategories.map((s) => s.toJson()).toList(),
  };
}
