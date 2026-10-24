import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/product.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_rating_stars.dart';

/// Product title, brand, rating, price, and description.
class ProductHeaderInfo extends StatelessWidget {
  final Product product;
  final VoidCallback? onRateTap;

  const ProductHeaderInfo({
    super.key,
    required this.product,
    this.onRateTap,
  });

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    // Directly reads updated user rating or average rating
    final displayRating = mockService.getDisplayRating(
      product.id,
      product.userRating ?? product.rating,
    );
    final reviewCount = mockService.getDisplayReviewCount(
      product.id,
      product.reviewCount,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                product.brand.toUpperCase(),
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: onRateTap,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: AppRatingStars(
                    rating: displayRating,
                    reviewCount: reviewCount,
                    starSize: 14,
                    starSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            product.title.toUpperCase(),
            style: AppTypography.headingLarge.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                product.price.toCurrency(),
                style: AppTypography.headingLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (product.originalPrice > product.price) ...[
                const SizedBox(width: 10),
                Text(
                  product.originalPrice.toCurrency(),
                  style: AppTypography.bodyMedium.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.placeholder,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tagBg,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    '-${product.discountPercent}% OFF',
                    style: AppTypography.badge.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'DETAILS & COMPOSITION',
            style: AppTypography.badge.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            product.description,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
