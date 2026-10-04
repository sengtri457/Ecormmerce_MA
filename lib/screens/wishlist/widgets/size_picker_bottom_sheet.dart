import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/product.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_button.dart';

/// Modal bottom sheet for selecting product size from the Wishlist screen.
/// Matches the high-end luxury aesthetic in the design specifications.
class SizePickerBottomSheet extends StatefulWidget {
  final Product product;
  final String? initialSize;
  final ValueChanged<String>? onSizeSelected;
  final VoidCallback? onGoToBag;

  const SizePickerBottomSheet({
    super.key,
    required this.product,
    this.initialSize,
    this.onSizeSelected,
    this.onGoToBag,
  });

  static Future<String?> show(
    BuildContext context, {
    required Product product,
    String? initialSize,
    VoidCallback? onGoToBag,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizePickerBottomSheet(
        product: product,
        initialSize: initialSize,
        onGoToBag: onGoToBag,
      ),
    );
  }

  @override
  State<SizePickerBottomSheet> createState() => _SizePickerBottomSheetState();
}

class _SizePickerBottomSheetState extends State<SizePickerBottomSheet> {
  late List<String> _sizes;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _sizes = widget.product.sizes.isNotEmpty
        ? widget.product.sizes
        : ['XS', 'S', 'M', 'L', 'XL'];

    final initial = widget.initialSize;
    if (initial != null && _sizes.contains(initial)) {
      _selectedIndex = _sizes.indexOf(initial);
    } else {
      _selectedIndex = 0;
    }
  }

  void _handleAddToBag() {
    final selectedSize = _sizes[_selectedIndex];
    final selectedColor = widget.product.colors.isNotEmpty
        ? widget.product.colors.first.name
        : 'Standard';

    MockDataService().addToCart(
      widget.product,
      color: selectedColor,
      size: selectedSize,
      quantity: 1,
    );

    widget.onSizeSelected?.call(selectedSize);
    Navigator.pop(context, selectedSize);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added "${widget.product.title}" ($selectedSize) to bag',
          style: AppTypography.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.black,
        duration: const Duration(seconds: 2),
        action: widget.onGoToBag != null
            ? SnackBarAction(
                label: 'GO TO BAG',
                textColor: AppColors.white,
                onPressed: widget.onGoToBag!,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Title centered with close button on right
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Size',
                    style: AppTypography.headingMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, size: 22, color: AppColors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Cupertino Picker for interactive luxury wheel selection
            SizedBox(
              height: 140,
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedIndex,
                ),
                selectionOverlay: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1.2),
                      bottom: BorderSide(color: AppColors.border, width: 1.2),
                    ),
                  ),
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _sizes.map((size) {
                  final isSelected = _sizes.indexOf(size) == _selectedIndex;
                  return Center(
                    child: Text(
                      size,
                      style: AppTypography.headingMedium.copyWith(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.placeholder,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            AppButton(
              text: 'ADD TO BAG',
              variant: AppButtonVariant.primary,
              onPressed: _handleAddToBag,
            ),
          ],
        ),
      ),
    );
  }
}
