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
        // Complimentary Delivery & Return Assurance
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_outlined, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Complimentary express delivery & 14-day doorstep returns included.',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

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

        // 2. SIZE & FIT
        _buildAccordionItem(
          context,
          title: 'SIZE & FIT',
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
