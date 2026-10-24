import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';

class BagPromoCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;

  const BagPromoCodeInput({
    super.key,
    required this.controller,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                controller: controller,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'PROMO CODE',
                  hintStyle: AppTypography.formLabel.copyWith(
                    color: AppColors.placeholder,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onApply,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: const BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(3),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'APPLY',
                style: AppTypography.badge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
