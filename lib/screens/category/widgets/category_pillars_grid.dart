import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/category_item.dart';
import '../../../widgets/app_image.dart';

class CategoryPillarsGrid extends StatelessWidget {
  final List<CategoryItem> categories;
  final void Function(CategoryItem category) onCategoryTap;
  final VoidCallback onNewInTap;

  const CategoryPillarsGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onNewInTap,
  });

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      ...categories.take(3).map((cat) {
        return _buildGridCard(
          title: cat.title,
          subtitle: '${cat.itemCount > 0 ? cat.itemCount : 35}+ Items',
          image: cat.image,
          onTap: () => onCategoryTap(cat),
        );
      }),
      _buildGridCard(
        title: 'NEW IN',
        subtitle: 'Curated SS26 Edit',
        image: 'assets/images/products/image1.jpg',
        badge: 'LIMITED',
        onTap: onNewInTap,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }

  Widget _buildGridCard({
    required String title,
    required String subtitle,
    required String image,
    String? fallback,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              imagePath: image,
              fallbackUrl: fallback,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.alertRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
