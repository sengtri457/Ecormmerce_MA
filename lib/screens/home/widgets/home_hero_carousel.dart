import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/department_content.dart';
import '../../../widgets/app_image.dart';

/// Department hero banner carousel with split typography and full-bleed editorial slides.
class HomeHeroCarousel extends StatelessWidget {
  final PageController controller;
  final List<HeroBannerSlide> slides;
  final int currentIndex;
  final Color promoColor;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<HeroBannerSlide> onSlideTap;

  const HomeHeroCarousel({
    super.key,
    required this.controller,
    required this.slides,
    required this.currentIndex,
    required this.promoColor,
    required this.onPageChanged,
    required this.onSlideTap,
  });

  @override
  Widget build(BuildContext context) {
    if (slides.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: slides.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () => onSlideTap(slide),
                  child: slide.isRedSplit
                      ? _buildSplitSlide(slide)
                      : _buildFullBleedSlide(slide),
                ),
              );
            },
          ),

          // Indicator Dots
          Positioned(
            bottom: 12,
            right: 32,
            child: Row(
              children: List.generate(slides.length, (idx) {
                final isActive = currentIndex == idx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(left: 4),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.white : AppColors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitSlide(HeroBannerSlide slide) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: promoColor,
      ),
      child: Row(
        children: [
          // Left Typography Box
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      slide.tag,
                      style: AppTypography.badge.copyWith(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.title,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.white,
                      fontSize: 24,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.subtitle,
                    style: AppTypography.badge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.95),
                      letterSpacing: 0.8,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      slide.cta,
                      style: AppTypography.badge.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Photo Box
          Expanded(
            flex: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
              child: AppImage(
                imagePath: slide.image,
                fallbackUrl: slide.fallback,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullBleedSlide(HeroBannerSlide slide) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AppImage(
              imagePath: slide.image,
              fallbackUrl: slide.fallback,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    slide.tag,
                    style: AppTypography.badge.copyWith(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  slide.title,
                  style: AppTypography.displayMedium.copyWith(color: AppColors.white, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  slide.subtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slide.cta,
                    style: AppTypography.badge.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
