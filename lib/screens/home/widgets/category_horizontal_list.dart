import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/category.dart';

class CategoryHorizontalList extends StatelessWidget {
  final List<Subcategory> subcategories;
  final ValueChanged<Subcategory> onSubCategoryTap;

  const CategoryHorizontalList({
    super.key,
    required this.subcategories,
    required this.onSubCategoryTap,
  });

  static Widget _buildCategoryIcon(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('discount') || lower.contains('sale')) {
      return const Icon(
        Icons.percent_rounded,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('t-shirt') ||
        lower.contains('shirt') ||
        lower.contains('tee')) {
      return const Icon(
        Icons.checkroom_outlined,
        size: 23,
        color: AppColors.black,
      );
    }
    if (lower.contains('hoodie') || lower.contains('sweat')) {
      return const Icon(
        Icons.dry_cleaning_outlined,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('hat') || lower.contains('cap')) {
      return const Icon(
        Icons.face_retouching_natural_outlined,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('dress')) {
      return const Icon(Icons.woman_outlined, size: 23, color: AppColors.black);
    }
    if (lower.contains('jacket') ||
        lower.contains('coat') ||
        lower.contains('outerwear')) {
      return const Icon(
        Icons.layers_outlined,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('shoe') || lower.contains('footwear')) {
      return const Icon(
        Icons.snowshoeing_outlined,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('bag') || lower.contains('leather')) {
      return const Icon(
        Icons.shopping_bag_outlined,
        size: 22,
        color: AppColors.black,
      );
    }
    if (lower.contains('pant') ||
        lower.contains('trouser') ||
        lower.contains('denim')) {
      return const Icon(Icons.tune_outlined, size: 22, color: AppColors.black);
    }
    if (lower.contains('decor') || lower.contains('home')) {
      return const Icon(Icons.home_outlined, size: 22, color: AppColors.black);
    }
    if (lower.contains('beauty') || lower.contains('fragrance')) {
      return const Icon(Icons.spa_outlined, size: 22, color: AppColors.black);
    }

    return const Icon(
      Icons.grid_view_outlined,
      size: 22,
      color: AppColors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subcategories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final sub = subcategories[index];

          return SizedBox(
            width: 72,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSubCategoryTap(sub),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(child: _buildCategoryIcon(sub.name)),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      sub.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
