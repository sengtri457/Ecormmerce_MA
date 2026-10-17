import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../helpers/currency_helper.dart';
import '../../../models/product.dart';
import '../../../widgets/app_image.dart';
import 'size_picker_bottom_sheet.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final String? selectedSize;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelectedChanged;
  final ValueChanged<String>? onSizeChanged;
  final VoidCallback? onGoToBag;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveToBag;

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
    this.onMoveToBag,
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
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.alertRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline, color: AppColors.white, size: 28),
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
              Padding(
                padding: const EdgeInsets.only(top: 50, right: 12),
                child: InkWell(
                  onTap: () => onSelectedChanged?.call(!isSelected),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? AppColors.black : AppColors.borderDark,
                        width: 1.4,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: AppColors.white)
                        : null,
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 95,
                  height: 130,
                  child: AppImage(
                    imagePath: product.images.isNotEmpty ? product.images.first : '',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.brand.toUpperCase(),
                            style: AppTypography.badge.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onRemove != null)
                          InkWell(
                            onTap: onRemove,
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.placeholder,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    Text(
                      product.title,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          product.price.toCurrency(),
                          style: AppTypography.headingSmall.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          const SizedBox(width: 6),
                          Text(
                            product.originalPrice.toCurrency(),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.placeholder,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.tagBg,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              '-${product.discountPercent}%',
                              style: AppTypography.badge.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.saleRed,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        InkWell(
                          onTap: () => _openSizePicker(context),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedSize != null ? 'SIZE: ${selectedSize!}' : 'SIZE',
                                  style: AppTypography.badge.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),

                        InkWell(
                          onTap: () {
                            if (onMoveToBag != null) {
                              onMoveToBag!();
                            } else {
                              _openSizePicker(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 13,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'MOVE TO BAG',
                                  style: AppTypography.badge.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    letterSpacing: 0.8,
                                  ),
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
