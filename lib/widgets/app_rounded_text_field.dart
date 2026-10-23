import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../helpers/app_typography.dart';

/// A rounded, styled text field matching MA Studio's modern input fields.
class AppRoundedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;

  const AppRoundedTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  State<AppRoundedTextField> createState() => _AppRoundedTextFieldState();
}

class _AppRoundedTextFieldState extends State<AppRoundedTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword || widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffixIcon = widget.suffixIcon;

    if (widget.isPassword) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _isObscured,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        hintText: widget.hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.placeholder),
        prefixIcon: widget.prefixIcon,
        suffixIcon: effectiveSuffixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.alertRed, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.alertRed, width: 1.5),
        ),
      ),
    );
  }
}
