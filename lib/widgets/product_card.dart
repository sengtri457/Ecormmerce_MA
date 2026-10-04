import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';
import '../helpers/currency_helper.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';
import 'app_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final firstImage = product.images.isNotEmpty ? product.images.first : '';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: AppImage(
                    imagePath: firstImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Top Left Badges (NEW / SALE)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.discountPercent > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: AppColors.alertRed,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: AppTypography.badge.copyWith(color: AppColors.white),
                          ),
                        ),
                      if (product.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'NEW IN',
                            style: AppTypography.badge.copyWith(color: AppColors.white),
                          ),
                        ),
                    ],
                  ),
                ),

                // Top Right Favorite Button (Isolated with ListenableBuilder)
                Positioned(
                  top: 8,
                  right: 8,
                  child: ListenableBuilder(
                    listenable: mockService,
                    builder: (context, _) {
                      final activeFav = mockService.isFavorite(product.id);
                      return GestureDetector(
                        onTap: () => mockService.toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            activeFav ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: activeFav ? AppColors.alertRed : AppColors.black,
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

          // Brand Label
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

          // Product Title
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

          // Price Row
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
    );
  }
}
