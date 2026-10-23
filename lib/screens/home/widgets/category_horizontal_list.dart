import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/category_pill_item.dart';

export '../../../models/category_pill_item.dart';

class CategoryHorizontalList extends StatelessWidget {
  final List<CategoryPillItem>? items;
  final String? department;
  final ValueChanged<CategoryPillItem> onItemTap;

  const CategoryHorizontalList({
    super.key,
    this.items,
    this.department,
    required this.onItemTap,
  });

  static const List<CategoryPillItem> defaultCategoryItems = [
    CategoryPillItem(
      id: 'clothes',
      label: 'Clothes',
      icon: 'assets/icons/category-horizental/Clothes.png',
    ),
    CategoryPillItem(
      id: 'shoes',
      label: 'Shoes',
      icon: 'assets/icons/category-horizental/shoes.png',
    ),
    CategoryPillItem(
      id: 'bags',
      label: 'Bags',
      icon: 'assets/icons/category-horizental/bag.png',
    ),
    CategoryPillItem(
      id: 'dresses',
      label: 'Dresses',
      icon: 'assets/icons/category-horizental/dress.png',
    ),
    CategoryPillItem(
      id: 'jackets',
      label: 'Jackets',
      icon: 'assets/icons/category-horizental/jacket.png',
    ),
    CategoryPillItem(
      id: 'coats',
      label: 'Coats',
      icon: 'assets/icons/category-horizental/coat.png',
    ),
    CategoryPillItem(
      id: 'caps',
      label: 'Caps',
      icon: 'assets/icons/category-horizental/cap.png',
    ),
  ];

  static List<CategoryPillItem> getItemsForDepartment(String? dept) {
    switch (dept?.toLowerCase()) {
      case 'women':
        return const [
          CategoryPillItem(
            id: 'clothes',
            label: 'Clothes',
            icon: 'assets/icons/category-horizental/Clothes.png',
          ),
          CategoryPillItem(
            id: 'dresses',
            label: 'Dresses',
            icon: 'assets/icons/category-horizental/dress.png',
          ),
          CategoryPillItem(
            id: 'shoes',
            label: 'Shoes',
            icon: 'assets/icons/category-horizental/shoes.png',
          ),
          CategoryPillItem(
            id: 'bags',
            label: 'Bags',
            icon: 'assets/icons/category-horizental/bag.png',
          ),
          CategoryPillItem(
            id: 'coats',
            label: 'Coats',
            icon: 'assets/icons/category-horizental/coat.png',
          ),
          CategoryPillItem(
            id: 'jackets',
            label: 'Jackets',
            icon: 'assets/icons/category-horizental/jacket.png',
          ),
        ];
      case 'men':
        return const [
          CategoryPillItem(
            id: 'clothes',
            label: 'Clothes',
            icon: 'assets/icons/category-horizental/Clothes.png',
          ),
          CategoryPillItem(
            id: 'jackets',
            label: 'Jackets',
            icon: 'assets/icons/category-horizental/jacket.png',
          ),
          CategoryPillItem(
            id: 'coats',
            label: 'Coats',
            icon: 'assets/icons/category-horizental/coat.png',
          ),
          CategoryPillItem(
            id: 'shoes',
            label: 'Shoes',
            icon: 'assets/icons/category-horizental/shoes.png',
          ),
          CategoryPillItem(
            id: 'bags',
            label: 'Bags',
            icon: 'assets/icons/category-horizental/bag.png',
          ),
          CategoryPillItem(
            id: 'caps',
            label: 'Caps',
            icon: 'assets/icons/category-horizental/cap.png',
          ),
        ];
      case 'kids':
        return const [
          CategoryPillItem(
            id: 'clothes',
            label: 'Clothes',
            icon: 'assets/icons/category-horizental/Clothes.png',
          ),
          CategoryPillItem(
            id: 'dresses',
            label: 'Dresses',
            icon: 'assets/icons/category-horizental/dress.png',
          ),
          CategoryPillItem(
            id: 'jackets',
            label: 'Jackets',
            icon: 'assets/icons/category-horizental/jacket.png',
          ),
          CategoryPillItem(
            id: 'shoes',
            label: 'Shoes',
            icon: 'assets/icons/category-horizental/shoes.png',
          ),
          CategoryPillItem(
            id: 'caps',
            label: 'Caps',
            icon: 'assets/icons/category-horizental/cap.png',
          ),
        ];
      default:
        return defaultCategoryItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = items ?? getItemsForDepartment(department);
    if (list.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 98,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = list[index];

          return SizedBox(
            width: 72,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onItemTap(item),
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
                      child: Center(
                        child: Image.asset(
                          item.icon,
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.grid_view_outlined,
                            size: 22,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.label,
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
