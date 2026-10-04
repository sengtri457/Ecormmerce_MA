import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../widgets/app_button.dart';

/// Modal bottom sheet for selecting product quantity in the Shopping Bag.
/// Matches the luxury Cupertino wheel picker aesthetic used across the app.
class QuantityPickerBottomSheet extends StatefulWidget {
  final int initialQuantity;
  final int maxQuantity;
  final ValueChanged<int>? onQuantitySelected;

  const QuantityPickerBottomSheet({
    super.key,
    this.initialQuantity = 1,
    this.maxQuantity = 10,
    this.onQuantitySelected,
  });

  static Future<int?> show(
    BuildContext context, {
    int initialQuantity = 1,
    int maxQuantity = 10,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuantityPickerBottomSheet(
        initialQuantity: initialQuantity,
        maxQuantity: maxQuantity,
      ),
    );
  }

  @override
  State<QuantityPickerBottomSheet> createState() => _QuantityPickerBottomSheetState();
}

class _QuantityPickerBottomSheetState extends State<QuantityPickerBottomSheet> {
  late int _selectedQuantity;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = widget.initialQuantity.clamp(1, widget.maxQuantity);
  }

  void _handleConfirm() {
    widget.onQuantitySelected?.call(_selectedQuantity);
    Navigator.pop(context, _selectedQuantity);
  }

  @override
  Widget build(BuildContext context) {
    final quantities = List.generate(widget.maxQuantity, (index) => index + 1);

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
                    'Quantity',
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

            // Cupertino Picker for smooth wheel selection
            SizedBox(
              height: 140,
              child: CupertinoPicker(
                itemExtent: 44,
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedQuantity - 1,
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
                    _selectedQuantity = quantities[index];
                  });
                },
                children: quantities.map((qty) {
                  final isSelected = qty == _selectedQuantity;
                  return Center(
                    child: Text(
                      '$qty',
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

            // Confirm Button
            AppButton(
              text: 'CONFIRM QUANTITY',
              variant: AppButtonVariant.primary,
              onPressed: _handleConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
