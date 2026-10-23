import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/product.dart';
import '../../../services/mock_data_service.dart';
import '../../../widgets/app_button.dart';

class SizePickerBottomSheet extends StatefulWidget {
  final Product product;
  final String? initialSize;
  final ValueChanged<String>? onSizeSelected;
  final VoidCallback? onGoToBag;
  final bool addToBagOnConfirm;
  final String? confirmButtonText;

  const SizePickerBottomSheet({
    super.key,
    required this.product,
    this.initialSize,
    this.onSizeSelected,
    this.onGoToBag,
    this.addToBagOnConfirm = true,
    this.confirmButtonText,
  });

  static Future<String?> show(
    BuildContext context, {
    required Product product,
    String? initialSize,
    VoidCallback? onGoToBag,
    bool addToBagOnConfirm = true,
    String? confirmButtonText,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizePickerBottomSheet(
        product: product,
        initialSize: initialSize,
        onGoToBag: onGoToBag,
        addToBagOnConfirm: addToBagOnConfirm,
        confirmButtonText: confirmButtonText,
      ),
    );
  }

  @override
  State<SizePickerBottomSheet> createState() => _SizePickerBottomSheetState();
}

class _SizePickerBottomSheetState extends State<SizePickerBottomSheet> {
  late List<String> _sizes;
  late int _selectedIndex;
  late final FixedExtentScrollController _scrollController;

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
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedIndex,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final selectedSize = _sizes[_selectedIndex];
    if (widget.addToBagOnConfirm) {
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
    } else {
      widget.onSizeSelected?.call(selectedSize);
      Navigator.pop(context, selectedSize);
    }
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

            SizedBox(
              height: 140,
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController: _scrollController,
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

            AppButton(
              text: widget.confirmButtonText ??
                  (widget.addToBagOnConfirm ? 'ADD TO BAG' : 'SELECT SIZE'),
              variant: AppButtonVariant.primary,
              onPressed: _handleConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
