import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';
import '../helpers/currency_helper.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';
import 'app_image.dart';
import 'app_rating_stars.dart';
import 'horizontal_product_card.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return HorizontalProductCard(product: product, onTap: onTap);
    }

    final mockService = MockDataService();
    final firstImage = product.images.isNotEmpty ? product.images.first : '';
    final fallbackUrl = product.images.length > 1 ? product.images[1] : null;

    return ListenableBuilder(
      listenable: mockService,
      builder: (context, _) {
        final displayRating = mockService.getDisplayRating(
          product.id,
          product.userRating ?? product.rating,
        );
        final reviewCount = mockService.getDisplayReviewCount(
          product.id,
          product.reviewCount,
        );
        final activeFav = mockService.isFavorite(product.id);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        child: AppImage(
                          imagePath: firstImage,
                          fallbackUrl: fallbackUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.discountPercent > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: AppColors.saleRed,
                                  borderRadius: BorderRadius.circular(AppRadius.xs),
                                ),
                                child: Text(
                                  '-${product.discountPercent}%',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            if (product.isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(AppRadius.xs),
                                ),
                                child: Text(
                                  'NEW IN',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => mockService.toggleFavorite(product.id),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.92),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  activeFav ? Icons.favorite : Icons.favorite_border,
                                  size: 17,
                                  color: activeFav ? AppColors.saleRed : AppColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.brand.toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  product.title,
                  style: AppTypography.headingSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                AppRatingStars.compact(
                  rating: displayRating,
                  reviewCount: reviewCount,
                  starSize: 12,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product.price.toCurrency(),
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (product.originalPrice > product.price) ...[
                      const SizedBox(width: 6),
                      Text(
                        product.originalPrice.toCurrency(),
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.placeholder,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
