class OnboardingItem {
  final int id;
  final String title;
  final String subtitle;
  final String image;

  OnboardingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory OnboardingItem.fromJson(Map<String, dynamic> json) {
    return OnboardingItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class CategoryBannerItem {
  final String id;
  final String title;
  final String imagePath;
  final String? fallbackUrl;
  final String slug;

  const CategoryBannerItem({
    required this.id,
    required this.title,
    required this.imagePath,
    this.fallbackUrl,
    required this.slug,
  });

  factory CategoryBannerItem.fromJson(Map<String, dynamic> json) {
    return CategoryBannerItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imagePath:
          (json['imagePath'] ?? json['image_path'] ?? json['image'])
              as String? ??
          '',
      fallbackUrl:
          (json['fallbackUrl'] ?? json['fallback_url'] ?? json['fallback'])
              as String? ??
          '',
      slug: (json['slug'] ?? json['id']) as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'fallbackUrl': fallbackUrl,
      'slug': slug,
    };
  }
}
