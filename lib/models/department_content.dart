import 'package:flutter/material.dart';

/// Represents a single slide in the home hero carousel.
class HeroBannerSlide {
  final bool isRedSplit;
  final String tag;
  final String title;
  final String subtitle;
  final String image;
  final bool isAsset;
  final String fallback;
  final String cta;
  final String category;

  const HeroBannerSlide({
    required this.isRedSplit,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isAsset,
    required this.fallback,
    required this.cta,
    required this.category,
  });
}

/// Represents the high-conversion split promo card.
class PromoBoxConfig {
  final String title;
  final String subtitle;
  final Color color;
  final String image;
  final bool isAsset;
  final String fallback;

  const PromoBoxConfig({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
    required this.isAsset,
    required this.fallback,
  });
}

/// Represents the editorial lookbook banner.
class LookbookConfig {
  final String tag;
  final String title;
  final String image;
  final String categoryTitle;

  const LookbookConfig({
    required this.tag,
    required this.title,
    required this.image,
    required this.categoryTitle,
  });
}

/// Strongly typed container holding all department-specific curated content.
class DepartmentContent {
  final String departmentId;
  final String departmentName;
  final List<HeroBannerSlide> slides;
  final PromoBoxConfig promoBox;
  final LookbookConfig lookbook;

  const DepartmentContent({
    required this.departmentId,
    required this.departmentName,
    required this.slides,
    required this.promoBox,
    required this.lookbook,
  });
}
