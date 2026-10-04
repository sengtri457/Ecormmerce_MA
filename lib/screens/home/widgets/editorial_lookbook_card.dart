import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/department_content.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_image.dart';

/// Full-width editorial lookbook showcase card.
class EditorialLookbookCard extends StatelessWidget {
  final LookbookConfig lookbook;
  final VoidCallback onViewLookbook;

  const EditorialLookbookCard({
    super.key,
    required this.lookbook,
    required this.onViewLookbook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AppImage(
              imagePath: lookbook.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lookbook.tag,
                  style: AppTypography.badge.copyWith(
                    color: AppColors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  lookbook.title,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'VIEW LOOKBOOK',
                  variant: AppButtonVariant.secondary,
                  height: 42,
                  onPressed: onViewLookbook,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
