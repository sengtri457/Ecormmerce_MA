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
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
    );
  }
}

class HomeBannerItem {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String ctaText;
  final String category;
  final String imageUrl;

  HomeBannerItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.category,
    required this.imageUrl,
  });

  factory HomeBannerItem.fromJson(Map<String, dynamic> json) {
    return HomeBannerItem(
      id: json['id'] as String,
      tag: json['tag'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      ctaText: json['ctaText'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class PromoOffer {
  final String id;
  final String code;
  final String title;
  final String condition;

  PromoOffer({
    required this.id,
    required this.code,
    required this.title,
    required this.condition,
  });

  factory PromoOffer.fromJson(Map<String, dynamic> json) {
    return PromoOffer(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      condition: json['condition'] as String,
    );
  }
}
