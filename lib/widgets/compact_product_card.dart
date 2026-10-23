import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';
import '../helpers/currency_helper.dart';
import '../models/product.dart';
import 'app_image.dart';

/// A compact, grid-friendly product card for MA Studio.
/// Useful for quick-browse lists, search suggestions, and featured grids.
class CompactProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final double width;

  const CompactProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.width = 170,
  });

  @override
  Widget build(BuildContext context) {
    final firstImage = product.images.isNotEmpty ? product.images.first : '';
    final subtitle = product.brand.isNotEmpty ? product.brand : product.subcategory;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image container
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  height: 110,
                  width: double.infinity,
                  color: AppColors.surfaceSubtle,
                  child: AppImage(
                    imagePath: firstImage,
                    fallbackUrl: product.images.length > 1 ? product.images[1] : null,
                    fit: BoxFit.cover,
                    errorWidget: const Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 36,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Title
              Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              // Brand / Subcategory
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Price & Add to Bag Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      CurrencyHelper.format(product.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onAddToCart,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.terracotta,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
