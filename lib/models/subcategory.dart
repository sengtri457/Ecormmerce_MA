class Subcategory {
  final String id;
  final String name;
  final int count;
  final String? icon;

  const Subcategory({
    required this.id,
    required this.name,
    this.count = 0,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'count': count,
    if (icon != null) 'icon': icon,
  };

  @override
  String toString() => name;
}
