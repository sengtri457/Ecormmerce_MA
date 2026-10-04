import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../widgets/app_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final RangeValues initialPrice;
  final String? initialCategory;
  final String? initialSize;
  final Function(RangeValues price, String? category, String? size) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialPrice,
    this.initialCategory,
    this.initialSize,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRange;
  String? _selectedCategory;
  String? _selectedSize;

  final List<String> _categories = ['All', 'Coats & Jackets', 'Dresses', 'Tops', 'Footwear', 'Bags'];
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _currentRange = widget.initialPrice;
    _selectedCategory = widget.initialCategory ?? 'All';
    _selectedSize = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FILTER & SORT',
                style: AppTypography.headingMedium.copyWith(letterSpacing: 1.0),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentRange = const RangeValues(50, 500);
                    _selectedCategory = 'All';
                    _selectedSize = null;
                  });
                },
                child: Text(
                  'RESET',
                  style: AppTypography.badge.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Range
          Text('PRICE RANGE', style: AppTypography.formLabel),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_currentRange.start.round()}', style: AppTypography.bodyMedium),
              Text('\$${_currentRange.end.round()}+', style: AppTypography.bodyMedium),
            ],
          ),
          RangeSlider(
            values: _currentRange,
            min: 0,
            max: 600,
            divisions: 12,
            activeColor: AppColors.black,
            inactiveColor: AppColors.border,
            onChanged: (values) {
              setState(() => _currentRange = values);
            },
          ),
          const SizedBox(height: 20),

          // Category Chips
          Text('CATEGORY', style: AppTypography.formLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(
                  cat,
                  style: AppTypography.bodySmall.copyWith(
                    color: isSel ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                selected: isSel,
                selectedColor: AppColors.black,
                backgroundColor: AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: isSel ? AppColors.black : AppColors.border),
                ),
                onSelected: (val) {
                  setState(() => _selectedCategory = val ? cat : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Size Chips
          Text('SIZE', style: AppTypography.formLabel),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _sizes.map((sz) {
              final isSel = _selectedSize == sz;
              return ChoiceChip(
                label: Text(
                  sz,
                  style: AppTypography.bodySmall.copyWith(
                    color: isSel ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                selected: isSel,
                selectedColor: AppColors.black,
                backgroundColor: AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: isSel ? AppColors.black : AppColors.border),
                ),
                onSelected: (val) {
                  setState(() => _selectedSize = val ? sz : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Apply Button
          AppButton(
            text: 'APPLY FILTERS',
            onPressed: () {
              widget.onApply(_currentRange, _selectedCategory, _selectedSize);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
