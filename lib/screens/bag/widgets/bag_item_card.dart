import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_dimensions.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/cart_item.dart';
import '../../../widgets/app_image.dart';
import 'quantity_picker_bottom_sheet.dart';

class BagItemCard extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelectedChanged;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveToWishlist;

  const BagItemCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
    this.onSelectedChanged,
    this.onQuantityChanged,
    this.onRemove,
    this.onMoveToWishlist,
  });

  void _openQuantityPicker(BuildContext context) async {
    final result = await QuantityPickerBottomSheet.show(
      context,
      initialQuantity: item.quantity,
      maxQuantity: 10,
    );
    if (result != null) {
      onQuantityChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemTotal = item.price * item.quantity;
    final displayPrice = itemTotal.toCurrency();

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.alertRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onMoveToWishlist != null) const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.white,
                size: 28,
              ),
              tooltip: 'Remove',
              onPressed: onRemove,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (onRemove != null) {
          onRemove!();
          return false;
        }
        return true;
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => onSelectedChanged?.call(!isSelected),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.black
                            : AppColors.borderDark,
                        width: 1.4,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: SizedBox(
                  width: 90,
                  height: 125,
                  child: AppImage(
                    imagePath: item.imageUrl,
                    fallbackUrl:
                        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title.toUpperCase(),
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    Text(
                      item.brand.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      displayPrice,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      'DESCRIPTIONS',
                      style: AppTypography.badge.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          'SIZE: ${item.size.toUpperCase()}',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () => _openQuantityPicker(context),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'QTY: ${item.quantity}',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
