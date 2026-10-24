import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../wishlist/wishlist_screen.dart';
import '../auth/sign_in_screen.dart';
import 'widgets/bag_item_card.dart';
import 'widgets/bag_empty_state.dart';
import 'widgets/bag_promo_code_input.dart';
import 'widgets/bag_order_summary.dart';

class ShoppingBagScreen extends StatefulWidget {
  final VoidCallback? onNavigateToWishlist;
  final VoidCallback? onBack;

  const ShoppingBagScreen({super.key, this.onNavigateToWishlist, this.onBack});

  @override
  State<ShoppingBagScreen> createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  final _promoController = TextEditingController(text: 'FIRST20');

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text('REMOVE ITEM', style: AppTypography.headingSmall),
        content: Text(
          'Are you sure you want to remove "$title" from your shopping bag?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: AppTypography.badge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saleRed,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              MockDataService().removeFromCart(cartItemId);
              Navigator.pop(ctx);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Removed "$title" from your bag',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.black,
                ),
              );
            },
            child: Text(
              'REMOVE',
              style: AppTypography.badge.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _moveToWishlist(String cartItemId, String title) {
    MockDataService().moveToWishlist(cartItemId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Moved "$title" to your wishlist',
          style: AppTypography.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.black,
        action: SnackBarAction(
          label: 'VIEW WISHLIST',
          textColor: AppColors.white,
          onPressed: _navigateToWishlist,
        ),
      ),
    );
  }

  Future<void> _handleCheckout() async {
    final mockService = MockDataService();
    if (!mockService.isLoggedIn) {
      final loggedIn = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInScreen(returnOnSuccess: true),
        ),
      );
      if (loggedIn == true && mounted) {
        _showCheckoutDialog();
      }
      return;
    }
    _showCheckoutDialog();
  }

  void _showCheckoutDialog() {
    MockDataService().clearSelectedCart();
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
            const Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.green,
            ),
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

  void _applyPromo(MockDataService mockService) {
    final success = mockService.applyPromoCode(_promoController.text);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Promo code "${_promoController.text.trim().toUpperCase()}" applied!',
          ),
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: 20,
          ),
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
            icon: const Icon(
              Icons.favorite_border,
              color: AppColors.black,
              size: 24,
            ),
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
            return BagEmptyState(onStartShopping: _handleBack);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          mockService.selectAllCartItems(
                            !mockService.isAllCartSelected,
                          );
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
                                  color: mockService.isAllCartSelected
                                      ? AppColors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: mockService.isAllCartSelected
                                      ? AppColors.black
                                      : AppColors.borderDark,
                                    width: 1.4,
                                  ),
                                ),
                                child: mockService.isAllCartSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: AppColors.white,
                                      )
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
                      onMoveToWishlist: () =>
                          _moveToWishlist(item.id, item.title),
                    );
                  },
                ),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BagPromoCodeInput(
                    controller: _promoController,
                    onApply: () => _applyPromo(mockService),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BagOrderSummary(
                    subtotal: mockService.cartSubtotal,
                    shippingFee: mockService.effectiveShippingFee,
                    discountAmount: mockService.effectiveDiscountAmount,
                    total: mockService.cartTotal,
                    selectedCount: mockService.selectedCartCount,
                    onCheckout: _handleCheckout,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
