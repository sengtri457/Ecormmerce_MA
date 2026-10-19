import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/banner_item.dart';
import '../../../services/mock_data_service.dart';

export '../../../models/banner_item.dart' show CategoryBannerItem;

class DepartmentCategoryGrid extends StatelessWidget {
  final List<CategoryBannerItem>? banners;
  final ValueChanged<CategoryBannerItem>? onBannerTap;

  const DepartmentCategoryGrid({super.key, this.banners, this.onBannerTap});

  @override
  Widget build(BuildContext context) {
    final list = banners ?? MockDataService().categoryBanners;
    if (list.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: list.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                if (onBannerTap != null) {
                  onBannerTap!(item);
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 145,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.surfaceSubtle,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.placeholder.withValues(
                                alpha: 0.5,
                              ),
                              size: 32,
                            ),
                          );
                        },
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
                            Colors.black.withValues(alpha: 0.70),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        item.title.toUpperCase(),
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
