import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';
import '../models/trust_badge_item.dart';

export '../models/trust_badge_item.dart';

class TrustBadges extends StatelessWidget {
  final List<TrustBadgeItem> items;
  final EdgeInsetsGeometry padding;
  final bool showTopBorder;

  const TrustBadges({
    super.key,
    this.items = defaultBadges,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    this.showTopBorder = true,
  });

  static const List<TrustBadgeItem> defaultBadges = [
    TrustBadgeItem(
      icon: Icons.local_shipping_outlined,
      title: 'GLOBAL EXPRESS',
      subtitle: 'Complimentary on all orders',
    ),
    TrustBadgeItem(
      icon: Icons.assignment_return_outlined,
      title: '14-DAY RETURNS',
      subtitle: 'Doorstep pickup available',
    ),
    TrustBadgeItem(
      icon: Icons.shield_outlined,
      title: 'AUTHENTIC & SECURE',
      subtitle: 'Direct from verified ateliers',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: showTopBorder
            ? const Border(top: BorderSide(color: AppColors.border, width: 0.8))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _TrustBadgeTile(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _TrustBadgeTile extends StatelessWidget {
  final TrustBadgeItem item;

  const _TrustBadgeTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 22, color: AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(
            item.title,
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
            item.subtitle,
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
