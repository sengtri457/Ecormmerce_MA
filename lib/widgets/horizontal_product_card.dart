import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';
import '../helpers/currency_helper.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';
import 'app_image.dart';
import 'app_rating_stars.dart';

class HorizontalProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const HorizontalProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final firstImage = product.images.isNotEmpty ? product.images.first : '';
    final fallbackUrl = product.images.length > 1 ? product.images[1] : null;

    return ListenableBuilder(
      listenable: mockService,
      builder: (context, _) {
        final activeFav = mockService.isFavorite(product.id);
        final displayRating = mockService.getDisplayRating(
          product.id,
          product.userRating ?? product.rating,
        );
        final reviewCount = mockService.getDisplayReviewCount(
          product.id,
          product.reviewCount,
        );

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: SizedBox(
                      width: 95,
                      height: 110,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(
                            imagePath: firstImage,
                            fallbackUrl: fallbackUrl,
                            fit: BoxFit.cover,
                          ),
                          if (product.discountPercent > 0)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.saleRed,
                                  borderRadius: BorderRadius.circular(AppRadius.xs),
                                ),
                                child: Text(
                                  '-${product.discountPercent}%',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.brand.toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
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
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        AppRatingStars.compact(
                          rating: displayRating,
                          reviewCount: reviewCount,
                          starSize: 11,
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
                                  fontSize: 11,
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
                  IconButton(
                    icon: Icon(
                      activeFav ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: activeFav ? AppColors.saleRed : AppColors.black,
                    ),
                    onPressed: () => mockService.toggleFavorite(product.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
