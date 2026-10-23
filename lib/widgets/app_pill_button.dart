import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';

/// A rounded pill-shaped button for quick actions, tags, or primary calls-to-action.
class AppPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isWide;
  final bool isLoading;
  final Widget? icon;
  final double height;

  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.terracotta,
    this.textColor = AppColors.white,
    this.isWide = false,
    this.isLoading = false,
    this.icon,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWide ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    label,
                    style: AppTypography.button.copyWith(
                      color: textColor,
                      fontSize: 14,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
