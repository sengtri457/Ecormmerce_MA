import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../widgets/app_button.dart';

/// Sticky bottom bar with quantity stepper and primary Add To Bag CTA.
class ProductBottomBar extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToBag;

  const ProductBottomBar({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity Stepper
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border.all(color: AppColors.border, width: 1.0),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppRadius.sm),
                      ),
                      onTap: onDecrement,
                      child: Container(
                        width: 38,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(Icons.remove, size: 16, color: AppColors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$quantity',
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(AppRadius.sm),
                      ),
                      onTap: onIncrement,
                      child: Container(
                        width: 38,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, size: 16, color: AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Add to Bag Button
            Expanded(
              child: AppButton(
                text: 'ADD TO BAG',
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.white,
                  size: 18,
                ),
                height: 48,
                onPressed: onAddToBag,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
