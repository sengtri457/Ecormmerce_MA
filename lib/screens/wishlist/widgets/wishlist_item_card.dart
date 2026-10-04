import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/product.dart';
import '../../../widgets/app_image.dart';
import 'size_picker_bottom_sheet.dart';

/// Single item row card for the Wishlist screen matching the luxury visual design.
/// Supports swipe-left to remove, size selection overlay, and selection toggle.
class WishlistItemCard extends StatelessWidget {
  final Product product;
  final String? selectedSize;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelectedChanged;
  final ValueChanged<String>? onSizeChanged;
  final VoidCallback? onGoToBag;
  final VoidCallback? onRemove;

  const WishlistItemCard({
    super.key,
    required this.product,
    this.selectedSize,
    this.isSelected = false,
    this.onTap,
    this.onSelectedChanged,
    this.onSizeChanged,
    this.onGoToBag,
    this.onRemove,
  });

  void _openSizePicker(BuildContext context) async {
    final result = await SizePickerBottomSheet.show(
      context,
      product: product,
      initialSize: selectedSize,
      onGoToBag: onGoToBag,
    );
    if (result != null) {
      onSizeChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice = product.price.toCurrency();

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.alertRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.white, size: 28),
          tooltip: 'Remove',
          onPressed: onRemove,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 95,
                  height: 130,
                  child: AppImage(
                    imagePath: product.images.isNotEmpty ? product.images.first : '',
                    fallbackUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Center: Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title.toUpperCase(),
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),

                    // Subtitle / Brand
                    Text(
                      product.brand.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Text(
                      displayPrice,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Descriptions label
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

                    // Size selector dropdown pill
                    InkWell(
                      onTap: () => _openSizePicker(context),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedSize != null ? selectedSize! : 'No size',
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
              ),

              // Right: Selection Checkbox / Toggle Box
              InkWell(
                onTap: () => onSelectedChanged?.call(!isSelected),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.black : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? AppColors.black : AppColors.borderDark,
                      width: 1.2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: AppColors.white)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
