import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/product.dart';

/// Clean editorial expansion accordion sections (Details, Size & Fit, Delivery & Returns).
class ProductAccordionSection extends StatelessWidget {
  final Product product;
  final VoidCallback onOpenSizeGuide;
  final VoidCallback onContactSupport;

  const ProductAccordionSection({
    super.key,
    required this.product,
    required this.onOpenSizeGuide,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Promo Banner Box
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPLORE OVER 3,500 LUXURY BRANDS',
                  style: AppTypography.badge.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enjoy complimentary shipping on all orders. Free 14-day returns collected directly from your door.',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // 1. THE DETAIL
        _buildAccordionItem(
          context,
          title: 'THE DETAIL',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Material: ${product.material.isNotEmpty ? product.material : "100% Virgin Wool / Organic Cotton"}',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Care: ${product.care.isNotEmpty ? product.care : "Specialist dry clean only."}',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Silhouette: Relaxed contemporary cut with dropped shoulders',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Hardware: Premium tonal finishing and architectural stitching',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),

        // 2. SIZE & FITS
        _buildAccordionItem(
          context,
          title: 'SIZE & FITS',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Fits true to standard international sizing.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Designed for a modern relaxed silhouette.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Model is 188cm / 6\'2" and wears size Medium.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: onOpenSizeGuide,
                child: Text(
                  'View Comprehensive Size Guide →',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. DELIVERY & RETURNS
        _buildAccordionItem(
          context,
          title: 'DELIVERY & RETURNS',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Express International Shipping: 2-4 business days.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Free 14-day doorstep return pickup included.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '• Carbon-neutral verified sustainable packaging.',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),

        // 4. CUSTOMER CARE
        _buildAccordionItem(
          context,
          title: 'CUSTOMER CARE',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our dedicated client concierge team is on hand 24/7 to assist with sizing advice, styling, or order tracking.',
                style: AppTypography.bodySmall.copyWith(height: 1.4),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: onContactSupport,
                child: Text(
                  'Contact Client Advisors →',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccordionItem(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            title,
            style: AppTypography.headingSmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.black,
            ),
          ),
          iconColor: AppColors.black,
          collapsedIconColor: AppColors.black,
          childrenPadding: const EdgeInsets.only(bottom: AppSpacing.md),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [content],
        ),
      ),
    );
  }
}
