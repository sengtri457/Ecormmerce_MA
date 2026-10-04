import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/color_extensions.dart';
import '../../../models/product.dart';

/// Clean color swatch selector for Product Detail screen.
class ProductColorSelector extends StatelessWidget {
  final List<ProductColor> colors;
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COLOR: ${selectedColor.toUpperCase()}',
            style: AppTypography.formLabel.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 10,
            children: colors.map((c) {
              final isSelected = selectedColor == c.name;
              return GestureDetector(
                onTap: () => onColorSelected(c.name),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      width: 1.8,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: c.hex.toColor(),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
