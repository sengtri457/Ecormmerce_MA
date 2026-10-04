import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';

/// Interactive size chips, size guide button, and one-size indicator.
class ProductSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final bool isOneSize;
  final ValueChanged<String> onSizeSelected;
  final VoidCallback onOpenSizeGuide;
  final VoidCallback onOpenSizeSheet;

  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.isOneSize,
    required this.onSizeSelected,
    required this.onOpenSizeGuide,
    required this.onOpenSizeSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onOpenSizeSheet,
                child: Text(
                  isOneSize
                      ? 'SELECT SIZE: ONE SIZE'
                      : 'SELECT SIZE: ${selectedSize.toUpperCase()}',
                  style: AppTypography.formLabel.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOpenSizeGuide,
                child: Text(
                  'Size Guide',
                  style: AppTypography.bodySmall.copyWith(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // If One Size (Accessories & Bags)
          if (isOneSize)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Text(
                      'OS',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Standard proportions fit all.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            // Sizing Chips Row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((size) {
                final isSelected = selectedSize == size;
                return InkWell(
                  onTap: () => onSizeSelected(size),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Container(
                    width: 48,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: isSelected ? AppColors.black : AppColors.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      size,
                      style: AppTypography.badge.copyWith(
                        color: isSelected ? AppColors.white : AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
