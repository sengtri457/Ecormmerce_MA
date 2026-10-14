import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';

/// Reusable luxury service guarantee strip (express delivery, returns, concierge).
class TrustBadges extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool showTopBorder;

  const TrustBadges({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    this.showTopBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: showTopBorder
            ? const Border(
                top: BorderSide(color: AppColors.border, width: 0.8),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TrustItem(
            icon: Icons.local_shipping_outlined,
            title: 'GLOBAL EXPRESS',
            subtitle: 'Complimentary on all orders',
          ),
          SizedBox(width: 8),
          _TrustItem(
            icon: Icons.assignment_return_outlined,
            title: '14-DAY RETURNS',
            subtitle: 'Doorstep pickup available',
          ),
          SizedBox(width: 8),
          _TrustItem(
            icon: Icons.shield_outlined,
            title: 'AUTHENTIC & SECURE',
            subtitle: 'Direct from verified ateliers',
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.badge.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
