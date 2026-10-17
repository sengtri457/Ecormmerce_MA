import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/currency_helper.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';
import 'app_image.dart';

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
    final mockService = MockDataService();
    final firstImage = product.images.isNotEmpty ? product.images.first : '';

    if (isHorizontal) {
      return _buildHorizontalCard(context, mockService, firstImage);
    }

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
                    fallbackUrl: product.images.length > 1 ? product.images[1] : null,
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
                  child: ListenableBuilder(
                    listenable: mockService,
                    builder: (context, _) {
                      final activeFav = mockService.isFavorite(product.id);
                      return Material(
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
                      );
                    },
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
          const SizedBox(height: 6),

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
}

  Widget _buildHorizontalCard(BuildContext context, MockDataService mockService, String firstImage) {
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
                      fallbackUrl: product.images.length > 1 ? product.images[1] : null,
                      fit: BoxFit.cover,
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                  const SizedBox(height: 6),
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

            ListenableBuilder(
              listenable: mockService,
              builder: (context, _) {
                final activeFav = mockService.isFavorite(product.id);
                return IconButton(
                  icon: Icon(
                    activeFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: activeFav ? AppColors.saleRed : AppColors.black,
                  ),
                  onPressed: () => mockService.toggleFavorite(product.id),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
