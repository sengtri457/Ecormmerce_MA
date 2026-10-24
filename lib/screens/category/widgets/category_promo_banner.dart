import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../widgets/app_button.dart';

class CategoryPromoBanner extends StatelessWidget {
  final VoidCallback onBrowse;

  const CategoryPromoBanner({
    super.key,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            'THE MINIMAL WARDROBE EDIT',
            style: AppTypography.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tactile natural fibers cut with architectural proportion and calm intent.',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton.outlined(
            text: 'BROWSE PRODUCTS',
            uppercase: true,
            width: 220,
            height: 42,
            onPressed: onBrowse,
          ),
        ],
      ),
    );
  }
}
