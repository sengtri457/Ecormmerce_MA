import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/product.dart';

/// Product title, brand, rating, price, and description for Product Detail screen.
class ProductHeaderInfo extends StatelessWidget {
  final Product product;

  const ProductHeaderInfo({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${product.rating}',
                    style: AppTypography.headingSmall.copyWith(fontSize: 13),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '(${product.reviewCount})',
                    style: AppTypography.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),

          // Title
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

          // Price Row with Strikethrough & Discount Tag
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

          // Descriptions header & body
          Text(
            'DESCRIPTIONS',
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
