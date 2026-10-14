import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../helpers/currency_helper.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../wishlist/wishlist_screen.dart';
import 'widgets/bag_item_card.dart';

/// Clean, editorial Shopping Bag screen matching the luxury design specification.
/// Features swipe-to-delete/move-to-wishlist, quantity picker overlay,
/// promo code integration, and streamlined checkout.
class ShoppingBagScreen extends StatefulWidget {
  final VoidCallback? onNavigateToWishlist;
  final VoidCallback? onBack;

  const ShoppingBagScreen({
    super.key,
    this.onNavigateToWishlist,
    this.onBack,
  });

  @override
  State<ShoppingBagScreen> createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  final _promoController = TextEditingController(text: 'FIRST20');

  void _navigateToWishlist() {
    if (widget.onNavigateToWishlist != null) {
      widget.onNavigateToWishlist!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WishlistScreen()),
      );
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _showRemoveDialog(String cartItemId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text('REMOVE ITEM', style: AppTypography.headingSmall),
        content: Text('Are you sure you want to remove "$title" from your shopping bag?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL', style: AppTypography.badge.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saleRed,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            onPressed: () {
              MockDataService().removeFromCart(cartItemId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "$title" from your bag', style: AppTypography.bodySmall.copyWith(color: AppColors.white)),
                  backgroundColor: AppColors.black,
                ),
              );
            },
            child: Text('REMOVE', style: AppTypography.badge.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _moveToWishlist(String cartItemId, String title) {
    MockDataService().moveToWishlist(cartItemId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "$title" to your wishlist', style: AppTypography.bodySmall.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.black,
        action: SnackBarAction(
          label: 'VIEW WISHLIST',
          textColor: AppColors.white,
          onPressed: _navigateToWishlist,
        ),
      ),
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('ORDER CONFIRMATION', style: AppTypography.headingSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              'Thank you for your order!',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your order #MA-99214 has been placed successfully and is being prepared.',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: 'CONTINUE SHOPPING',
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
          onPressed: _handleBack,
        ),
        title: Text(
          'SHOPPING BAG',
          style: AppTypography.headingSmall.copyWith(
            letterSpacing: 2.0,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.black, size: 24),
            onPressed: _navigateToWishlist,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: mockService,
        builder: (context, _) {
          final items = mockService.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 36,
                        color: AppColors.placeholder,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'YOUR BAG IS EMPTY',
                      style: AppTypography.headingMedium.copyWith(letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Items added to your shopping bag will appear here.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      text: 'START SHOPPING',
                      variant: AppButtonVariant.primary,
                      onPressed: _handleBack,
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select All Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          mockService.selectAllCartItems(!mockService.isAllCartSelected);
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: mockService.isAllCartSelected ? AppColors.black : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: mockService.isAllCartSelected ? AppColors.black : AppColors.borderDark,
                                    width: 1.4,
                                  ),
                                ),
                                child: mockService.isAllCartSelected
                                    ? const Icon(Icons.check, size: 14, color: AppColors.white)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'SELECT ALL',
                                style: AppTypography.badge.copyWith(
                                  fontSize: 11,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${mockService.selectedCartCount} OF ${items.length} SELECTED',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),

                // Cart Items List (with swipe to delete)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(
                    color: AppColors.border,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return BagItemCard(
                      item: item,
                      isSelected: item.isSelected,
                      onSelectedChanged: (val) {
                        mockService.toggleCartItemSelection(item.id, val);
                      },
                      onQuantityChanged: (newQty) {
                        mockService.setCartQuantity(item.id, newQty);
                      },
                      onRemove: () => _showRemoveDialog(item.id, item.title),
                      onMoveToWishlist: () => _moveToWishlist(item.id, item.title),
                    );
                  },
                ),

                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 20),

                // Promo Code Section (matching mockup)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: TextField(
                              controller: _promoController,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'PROMO CODE',
                                hintStyle: AppTypography.formLabel.copyWith(
                                  color: AppColors.placeholder,
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final success = mockService.applyPromoCode(_promoController.text);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Promo code "${_promoController.text.trim().toUpperCase()}" applied!'),
                                  backgroundColor: AppColors.black,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid promo code. Try FIRST20 or VIP10.'),
                                  backgroundColor: AppColors.saleRed,
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            decoration: const BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(3)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'APPLY',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Order Price Breakdown (Matching mockup)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _priceRow('Sub-Total', mockService.cartSubtotal.toCurrency()),
                      const SizedBox(height: 10),
                      _priceRow('Delivery Fee', mockService.effectiveShippingFee.toCurrency()),
                      const SizedBox(height: 10),
                      _priceRow(
                        'Discount',
                        mockService.effectiveDiscountAmount.toDiscountCurrency(),
                        isDiscount: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: AppColors.border, height: 1),
                      ),
                      _priceRow(
                        'Total Cost',
                        mockService.cartTotal.toCurrency(),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Checkout Button (Matching mockup "Go To Bag" / "PROCEED TO CHECKOUT")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppButton(
                    text: mockService.selectedCartCount > 0
                        ? 'PROCEED TO CHECKOUT • ${mockService.cartTotal.toCurrency()}'
                        : 'SELECT ITEMS TO CHECKOUT',
                    variant: mockService.selectedCartCount > 0
                        ? AppButtonVariant.primary
                        : AppButtonVariant.secondary,
                    onPressed: mockService.selectedCartCount > 0
                        ? _showCheckoutDialog
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select at least one item to proceed.'),
                                backgroundColor: AppColors.black,
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.headingSmall.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)
              : AppTypography.bodySmall.copyWith(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.headingSmall.copyWith(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)
              : AppTypography.bodySmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? AppColors.alertRed : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
