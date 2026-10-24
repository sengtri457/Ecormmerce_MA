import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/category_item.dart';
import '../../../widgets/app_image.dart';

class CategoryPillarCard extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;
  final void Function(String subcategoryName) onSubcategoryTap;

  const CategoryPillarCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(imagePath: category.image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.70),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 14,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: AppTypography.headingLarge.copyWith(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${category.itemCount > 0 ? category.itemCount : 40}+ ITEMS',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.white.withValues(alpha: 0.85),
                                fontSize: 10,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.5),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'VIEW ALL',
                                style: AppTypography.badge.copyWith(
                                  color: AppColors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 9,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: category.subcategories.map((sub) {
                final subName = sub.name;
                final isAll = subName.startsWith('All');
                return InkWell(
                  onTap: () => onSubcategoryTap(subName),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isAll ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isAll ? AppColors.black : AppColors.border,
                      ),
                    ),
                    child: Text(
                      subName,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: isAll ? FontWeight.w700 : FontWeight.w500,
                        color: isAll ? AppColors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
