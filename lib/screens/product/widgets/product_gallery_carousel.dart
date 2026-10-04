import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/product.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_image.dart';

/// Horizontal multi-card image gallery for Product Detail screen.
/// Includes badges for discounts, new-in status, and favorite toggle button.
class ProductGalleryCarousel extends StatelessWidget {
  final Product product;
  final List<String> images;

  const ProductGalleryCarousel({
    super.key,
    required this.product,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

    return SizedBox(
      height: 360,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final img = images[index];
          final cardWidth = images.length == 1
              ? MediaQuery.of(context).size.width - 32
              : MediaQuery.of(context).size.width * 0.74;

          return SizedBox(
            width: cardWidth,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: Container(
                    color: AppColors.surfaceSubtle,
                    width: double.infinity,
                    height: double.infinity,
                    child: AppImage(
                      imagePath: img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Discount & New In Badges on First Card
                if (index == 0)
                  Positioned(
                    top: 14,
                    left: 14,
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
                              color: AppColors.alertRed,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              '-${product.discountPercent}%',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
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
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              'NEW IN',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Favorite Heart Icon at Top Right of Image Card
                Positioned(
                  top: 14,
                  right: 14,
                  child: ListenableBuilder(
                    listenable: mockService,
                    builder: (context, _) {
                      final isFav = mockService.isFavorite(product.id);
                      return GestureDetector(
                        onTap: () => mockService.toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
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
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFav ? AppColors.alertRed : AppColors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
