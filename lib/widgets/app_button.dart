import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined }

/// Design-system button adhering to the MA Studio luxury aesthetic.
/// Supports standard filled, subtle secondary, and outlined borders.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? borderColor;
  final bool uppercase;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
    this.borderRadius = AppRadius.md,
    this.borderColor,
    this.uppercase = true,
    this.fontSize,
  });

  /// Factory constructor for clean, luxury outlined buttons (e.g. "Shop Now").
  factory AppButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double height = 46.0,
    double borderRadius = AppRadius.xs,
    Color borderColor = AppColors.black,
    bool uppercase = false,
    Widget? icon,
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.outlined,
      width: width,
      height: height,
      borderRadius: borderRadius,
      borderColor: borderColor,
      uppercase: uppercase,
      icon: icon,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BorderSide borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = AppColors.black;
        textColor = AppColors.white;
        borderSide = BorderSide.none;
        break;
      case AppButtonVariant.secondary:
        bgColor = AppColors.surfaceLight;
        textColor = AppColors.black;
        borderSide = BorderSide.none;
        break;
      case AppButtonVariant.outlined:
        bgColor = Colors.transparent;
        textColor = AppColors.black;
        borderSide = BorderSide(
          color: borderColor ?? AppColors.black,
          width: 1.2,
        );
        break;
    }

    final displayText = uppercase ? text.toUpperCase() : text;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      displayText,
                      style: AppTypography.button.copyWith(
                        color: textColor,
                        fontSize: fontSize ?? (uppercase ? 13 : 14),
                        fontWeight: FontWeight.w600,
                        letterSpacing: uppercase ? 1.2 : 0.4,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
