import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/banner_item.dart';
import '../../../models/category.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_image.dart';

export '../../../models/banner_item.dart' show CategoryBannerItem;

class DepartmentCategoryGrid extends StatelessWidget {
  final List<Subcategory>? subcategories;
  final ValueChanged<Subcategory>? onSubCategoryTap;
  final ValueChanged<CategoryBannerItem>? onBannerTap;
  final List<CategoryBannerItem>? customBanners;

  const DepartmentCategoryGrid({
    super.key,
    this.subcategories,
    this.onSubCategoryTap,
    this.onBannerTap,
    this.customBanners,
  });
  static const List<CategoryBannerItem> defaultBanners = [
    CategoryBannerItem(
      id: 'tees',
      title: 'T-SHIRT',
      imagePath: 'assets/images/categories/t_shirt.jpg',
      fallbackUrl:
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=1000&auto=format&fit=crop&q=80',
      slug: 'tees',
    ),
    CategoryBannerItem(
      id: 'hoodies',
      title: 'HOODIES',
      imagePath: 'assets/images/categories/hoodies.jpg',
      fallbackUrl:
          'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=1000&auto=format&fit=crop&q=80',
      slug: 'hoodies',
    ),
    CategoryBannerItem(
      id: 'hat',
      title: 'HAT',
      imagePath: 'assets/images/categories/hat.jpg',
      fallbackUrl:
          'https://images.unsplash.com/photo-1534215754734-18e55d13e346?w=1000&auto=format&fit=crop&q=80',
      slug: 'hats',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final banners = customBanners ?? _buildBannersFromSubcategories();
    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: banners.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                if (onBannerTap != null) {
                  onBannerTap!(item);
                } else if (onSubCategoryTap != null) {
                  onSubCategoryTap!(
                    Subcategory(id: item.id, name: item.title, count: 0),
                  );
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 145,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AppImage(
                        imagePath: item.imagePath,
                        fallbackUrl: item.fallbackUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.70),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        item.title.toUpperCase(),
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<CategoryBannerItem> _buildBannersFromSubcategories() {
    final mockBanners = MockDataService().categoryBanners;
    if (subcategories == null || subcategories!.isEmpty) {
      return mockBanners.isNotEmpty ? mockBanners : defaultBanners;
    }

    final topItems = subcategories!.take(4).toList();
    return topItems.map((sub) {
      final key = sub.name.toLowerCase();
      String imagePath = 'assets/images/categories/$key.jpg';
      String fallback = defaultBanners.first.fallbackUrl;

      if (key.contains('t-shirt') || key.contains('tee')) {
        imagePath = 'assets/images/categories/t_shirt.jpg';
        fallback = defaultBanners[0].fallbackUrl;
      } else if (key.contains('hoodie')) {
        imagePath = 'assets/images/categories/hoodies.jpg';
        fallback = defaultBanners[1].fallbackUrl;
      } else if (key.contains('hat')) {
        imagePath = 'assets/images/categories/hat.jpg';
        fallback = defaultBanners[2].fallbackUrl;
      } else if (key.contains('dress')) {
        imagePath = 'assets/images/categories/dresses.jpg';
        fallback =
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1000&auto=format&fit=crop&q=80';
      } else if (key.contains('jacket') || key.contains('coat')) {
        imagePath = 'assets/images/categories/jackets.jpg';
        fallback =
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=1000&auto=format&fit=crop&q=80';
      } else if (key.contains('shoe')) {
        imagePath = 'assets/images/categories/shoes.jpg';
        fallback =
            'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=1000&auto=format&fit=crop&q=80';
      } else if (key.contains('bag')) {
        imagePath = 'assets/images/categories/bags.jpg';
        fallback =
            'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=1000&auto=format&fit=crop&q=80';
      }

      return CategoryBannerItem(
        id: sub.id,
        title: sub.name,
        imagePath: imagePath,
        fallbackUrl: fallback,
        slug: sub.id,
      );
    }).toList();
  }
}
