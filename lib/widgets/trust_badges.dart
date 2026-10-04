import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_typography.dart';

/// Reusable trust badges section showing shipping, return, and payment guarantees.
class TrustBadges extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool showTopBorder;

  const TrustBadges({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
    this.showTopBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: showTopBorder
            ? const Border(
                top: BorderSide(color: AppColors.border, width: 1.0),
              )
            : null,
      ),
      child: Row(
        children: const [
          _TrustItem(
            icon: Icons.local_shipping_outlined,
            title: 'GLOBAL SHIPPING',
          ),
          _TrustItem(
            icon: Icons.inventory_2_outlined,
            title: '14-DAY RETURN',
          ),
          _TrustItem(
            icon: Icons.lock_outline_rounded,
            title: 'SECURE PAYMENT',
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _TrustItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 38,
            color: AppColors.black,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.badge.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
