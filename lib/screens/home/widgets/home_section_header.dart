import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String actionText;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry padding;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText = 'VIEW ALL',
    this.onActionTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headingSmall.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onActionTap != null && subtitle == null)
                GestureDetector(
                  onTap: onActionTap,
                  child: Text(
                    actionText,
                    style: AppTypography.badge.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColors.black,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
