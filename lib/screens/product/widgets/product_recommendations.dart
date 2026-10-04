import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/product.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_image.dart';
import '../../catalog/product_list_screen.dart';
import '../product_detail_screen.dart';

/// Recommendations and Editorial styling section at the bottom of Product Detail.
class ProductRecommendations extends StatelessWidget {
  final Product currentProduct;
  final List<Product> recommendedProducts;

  const ProductRecommendations({
    super.key,
    required this.currentProduct,
    required this.recommendedProducts,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendedProducts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STYLE WITH',
            style: AppTypography.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Curated pieces chosen by our atelier stylists to complete this look.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Two-column side-by-side recommended cards
          Row(
            children: recommendedProducts.take(2).map((rec) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: rec),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: Container(
                                height: 180,
                                color: AppColors.surfaceSubtle,
                                width: double.infinity,
                                child: AppImage(
                                  imagePath: rec.images.isNotEmpty ? rec.images.first : '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: AppColors.black.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'New Season',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          rec.brand.toUpperCase(),
                          style: AppTypography.badge.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          rec.title,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rec.price.toCurrency(),
                          style: AppTypography.badge.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Outlined Shop Now CTA
          const SizedBox(height: AppSpacing.xl),
          AppButton.outlined(
            text: 'Shop Now',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    categorySlug: currentProduct.category,
                    categoryTitle: 'Recommended Collection',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
