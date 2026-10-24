import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/product.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_image.dart';
import '../../../widgets/app_rating_stars.dart';

class RateProductBottomSheet extends StatefulWidget {
  final Product product;

  const RateProductBottomSheet({super.key, required this.product});

  static Future<bool?> show(BuildContext context, {required Product product}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RateProductBottomSheet(product: product),
    );
  }

  @override
  State<RateProductBottomSheet> createState() => _RateProductBottomSheetState();
}

class _RateProductBottomSheetState extends State<RateProductBottomSheet> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    // Default to existing user rating, or 5.0
    _currentRating = widget.product.userRating ?? 5.0;
  }

  String _getRatingFeedback(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Needs Improvement';
      case 2:
        return 'Fair Quality';
      case 3:
        return 'Good Experience';
      case 4:
        return 'Very Good';
      case 5:
      default:
        return 'Exceptional Quality';
    }
  }

  void _submitRating() {
    MockDataService().rateProduct(
      widget.product.id,
      _currentRating,
      widget.product,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.product.images.isNotEmpty ? widget.product.images.first : '';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Product Summary Row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: AppImage(
                    imagePath: imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.brand.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.product.title,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Rating Prompt Title
          Text(
            'RATE THIS PRODUCT',
            style: AppTypography.headingMedium.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap a star to give your score',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Interactive 5 Stars
          AppRatingStars.interactive(
            rating: _currentRating,
            starSize: 36.0,
            starSpacing: 10.0,
            onRatingChanged: (val) {
              setState(() => _currentRating = val);
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Quality feedback text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _getRatingFeedback(_currentRating),
              key: ValueKey<double>(_currentRating),
              style: AppTypography.headingSmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.terracotta,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Submit Button
          AppButton(
            text: 'SUBMIT RATING',
            onPressed: _submitRating,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
