import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../widgets/app_button.dart';

class BagEmptyState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const BagEmptyState({
    super.key,
    required this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 36,
                color: AppColors.placeholder,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'YOUR BAG IS EMPTY',
              style: AppTypography.headingMedium.copyWith(
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Items added to your shopping bag will appear here.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 28),
            AppButton(
              text: 'START SHOPPING',
              variant: AppButtonVariant.primary,
              onPressed: onStartShopping,
            ),
          ],
        ),
      ),
    );
  }
}
