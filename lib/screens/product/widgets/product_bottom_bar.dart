import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../widgets/app_button.dart';

/// Bottom bar with size selector, quantity stepper and Add to Bag button.
class ProductBottomBar extends StatelessWidget {
  final int quantity;
  final String selectedSize;
  final bool isOneSize;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToBag;
  final VoidCallback onOpenSizePicker;

  const ProductBottomBar({
    super.key,
    required this.quantity,
    required this.selectedSize,
    this.isOneSize = false,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
    required this.onOpenSizePicker,
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
            InkWell(
              onTap: onOpenSizePicker,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  border: Border.all(color: AppColors.border, width: 1.0),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isOneSize ? 'OS' : selectedSize,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

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
                        width: 34,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(Icons.remove, size: 16, color: AppColors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
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
                        width: 34,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, size: 16, color: AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

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
