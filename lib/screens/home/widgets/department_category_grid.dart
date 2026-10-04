import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/category.dart';

class DepartmentCategoryGrid extends StatelessWidget {
  final List<Subcategory> subcategories;
  final ValueChanged<Subcategory> onSubCategoryTap;
  final int maxItems;

  const DepartmentCategoryGrid({
    super.key,
    required this.subcategories,
    required this.onSubCategoryTap,
    this.maxItems = 4,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = subcategories.take(maxItems).toList();
    if (displayItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final sub = displayItems[index];
          return InkWell(
            onTap: () => onSubCategoryTap(sub),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sub.name.toUpperCase(),
                    style: AppTypography.formLabel.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('${sub.count} Items', style: AppTypography.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
