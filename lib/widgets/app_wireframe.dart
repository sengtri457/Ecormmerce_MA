import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';

/// A luxury skeleton wireframe system for MA Studio.
/// Displays animated placeholder layouts while content is loading,
/// eliminating perceived wait times and providing immediate visual feedback.
class AppWireframe extends StatefulWidget {
  final Widget child;

  const AppWireframe({super.key, required this.child});

  /// Generic wireframe box (banners, cards, image placeholders)
  static Widget box({
    double? width,
    required double height,
    double borderRadius = AppRadius.md,
    EdgeInsetsGeometry? margin,
  }) {
    return AppWireframe(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
      ),
    );
  }

  /// Circular wireframe element (avatars, action buttons)
  static Widget circle({required double size, EdgeInsetsGeometry? margin}) {
    return AppWireframe(
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
      ),
    );
  }

  /// Text line wireframe placeholder
  static Widget text({
    double? width,
    double height = 12.0,
    double borderRadius = AppRadius.xs,
    EdgeInsetsGeometry? margin,
  }) {
    return AppWireframe(
      child: Container(
        width: width ?? 120,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Hero Carousel Wireframe Placeholder
  static Widget heroBanner({double height = 240}) {
    return AppWireframe.box(
      width: double.infinity,
      height: height,
      borderRadius: AppRadius.lg,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    );
  }

  /// Category Pills Wireframe Row
  static Widget categoryPills({int count = 5}) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, index) => AppWireframe.box(
          width: 80.0 + (index % 3) * 16.0,
          height: 36,
          borderRadius: AppRadius.pill,
        ),
      ),
    );
  }

  /// Product Card Wireframe (mimics ProductCard dimensions)
  static Widget productCard({double width = 160}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image skeleton
          AppWireframe.box(
            width: double.infinity,
            height: 140,
            borderRadius: AppRadius.md,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Title skeleton
          AppWireframe.text(width: 110, height: 14),
          const SizedBox(height: 6),
          // Subtitle skeleton
          AppWireframe.text(width: 70, height: 11),
          const SizedBox(height: AppSpacing.md),
          // Price and button skeleton row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppWireframe.text(width: 50, height: 16),
              AppWireframe.box(width: 32, height: 32, borderRadius: AppRadius.md),
            ],
          ),
        ],
      ),
    );
  }

  /// 2-Column Product Grid Wireframe
  static Widget productGrid({int itemCount = 4}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => AppWireframe.productCard(),
    );
  }

  /// Horizontal List Item Wireframe (for Bag, Wishlist, or Category lists)
  static Widget listTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AppWireframe.box(width: 70, height: 85, borderRadius: AppRadius.sm),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWireframe.text(width: 140, height: 14),
                const SizedBox(height: 6),
                AppWireframe.text(width: 90, height: 11),
                const SizedBox(height: 12),
                AppWireframe.text(width: 60, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Full screen product detail wireframe
  static Widget productDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWireframe.box(width: double.infinity, height: 380, borderRadius: 0),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWireframe.text(width: 220, height: 20),
              const SizedBox(height: 8),
              AppWireframe.text(width: 140, height: 14),
              const SizedBox(height: 16),
              AppWireframe.text(width: 90, height: 22),
              const SizedBox(height: 24),
              AppWireframe.categoryPills(count: 4),
            ],
          ),
        ),
      ],
    );
  }

  @override
  State<AppWireframe> createState() => _AppWireframeState();
}

class _AppWireframeState extends State<AppWireframe>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _opacityAnim = Tween<double>(begin: 0.45, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
