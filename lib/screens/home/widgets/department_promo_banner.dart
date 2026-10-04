import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/department_content.dart';
import '../../../widgets/app_image.dart';

class DepartmentPromoBanner extends StatelessWidget {
  final PromoBoxConfig promo;
  final VoidCallback? onTap;

  const DepartmentPromoBanner({super.key, required this.promo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: promo.color,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 12,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.title,
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        promo.subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(6),
                  ),
                  child: AppImage(
                    imagePath: promo.image,
                    fallbackUrl: promo.fallback,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
