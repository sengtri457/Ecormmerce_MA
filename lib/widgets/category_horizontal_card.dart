import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';
import '../models/category_item.dart';
import 'app_image.dart';

/// A horizontal card component for showcasing catalog categories or departments.
class CategoryHorizontalCard extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CategoryHorizontalCard({
    super.key,
    required this.category,
    this.onTap,
    this.width = 240,
    this.height = 96,
  });

  @override
  Widget build(BuildContext context) {
    final imageSource = category.image.isNotEmpty ? category.image : category.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Row(
            children: [
              // Category Thumbnail / Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  width: 60,
                  height: 60,
                  color: AppColors.white,
                  child: AppImage(
                    imagePath: imageSource,
                    fit: BoxFit.cover,
                    errorWidget: const Center(
                      child: Icon(
                        Icons.category_outlined,
                        size: 28,
                        color: AppColors.terracotta,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Title and Item Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.itemCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${category.itemCount} items',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
