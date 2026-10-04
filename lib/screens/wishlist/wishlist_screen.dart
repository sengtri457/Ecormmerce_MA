import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../bag/shopping_bag_screen.dart';
import '../product/product_detail_screen.dart';
import 'widgets/wishlist_item_card.dart';

/// Clean, editorial Wishlist screen matching the luxury design specification.
/// Features interactive size selection, item selection, and direct Bag navigation.
class WishlistScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBag;
  final VoidCallback? onBack;

  const WishlistScreen({
    super.key,
    this.onNavigateToBag,
    this.onBack,
  });

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final Map<String, String> _selectedSizes = {};
  final Set<String> _selectedItemIds = {};

  void _navigateToBag() {
    if (widget.onNavigateToBag != null) {
      widget.onNavigateToBag!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ShoppingBagScreen()),
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

  void _addSelectedToBag() {
    final mockService = MockDataService();
    final itemsToAdd = mockService.wishlistProducts.where((p) => _selectedItemIds.contains(p.id)).toList();

    if (itemsToAdd.isEmpty) {
      // If none explicitly ticked, add all wishlist items
      for (final product in mockService.wishlistProducts) {
        final size = _selectedSizes[product.id] ?? (product.sizes.isNotEmpty ? product.sizes.first : 'M');
        final color = product.colors.isNotEmpty ? product.colors.first.name : 'Standard';
        mockService.addToCart(product, color: color, size: size);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added all wishlist items to your bag', style: AppTypography.bodySmall.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.black,
          action: SnackBarAction(label: 'GO TO BAG', textColor: AppColors.white, onPressed: _navigateToBag),
        ),
      );
    } else {
      for (final product in itemsToAdd) {
        final size = _selectedSizes[product.id] ?? (product.sizes.isNotEmpty ? product.sizes.first : 'M');
        final color = product.colors.isNotEmpty ? product.colors.first.name : 'Standard';
        mockService.addToCart(product, color: color, size: size);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${itemsToAdd.length} item(s) to your bag', style: AppTypography.bodySmall.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.black,
          action: SnackBarAction(label: 'GO TO BAG', textColor: AppColors.white, onPressed: _navigateToBag),
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
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
          onPressed: _handleBack,
        ),
        title: Text(
          'WISH LIST',
          style: AppTypography.headingSmall.copyWith(
            letterSpacing: 2.0,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: mockService,
            builder: (context, _) {
              final bagCount = mockService.cartItems.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.black, size: 24),
                    onPressed: _navigateToBag,
                  ),
                  if (bagCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.alertRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Center(
                          child: Text(
                            '$bagCount',
                            style: AppTypography.badge.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: mockService,
        builder: (context, _) {
          final items = mockService.wishlistProducts;

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
                        Icons.favorite_border,
                        size: 36,
                        color: AppColors.placeholder,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'YOUR WISHLIST IS EMPTY',
                      style: AppTypography.headingMedium.copyWith(letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite pieces here to view or purchase them later.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      text: 'EXPLORE COLLECTIONS',
                      variant: AppButtonVariant.primary,
                      onPressed: _handleBack,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Wishlist Items List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: AppColors.border,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final isSelected = _selectedItemIds.contains(product.id);

                    return WishlistItemCard(
                      product: product,
                      selectedSize: _selectedSizes[product.id],
                      isSelected: isSelected,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      onSelectedChanged: (val) {
                        setState(() {
                          if (val) {
                            _selectedItemIds.add(product.id);
                          } else {
                            _selectedItemIds.remove(product.id);
                          }
                        });
                      },
                      onSizeChanged: (newSize) {
                        setState(() {
                          _selectedSizes[product.id] = newSize;
                        });
                      },
                      onGoToBag: _navigateToBag,
                      onRemove: () => mockService.toggleFavorite(product.id),
                    );
                  },
                ),
              ),

              // Bottom Sticky "GO TO BAG" Action Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // If items are checked, offer "Add selected to bag"
                      if (_selectedItemIds.isNotEmpty) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _addSelectedToBag,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.black, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Text(
                              'ADD (${_selectedItemIds.length}) TO BAG',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      // Main "GO TO BAG" Button
                      Expanded(
                        child: AppButton(
                          text: mockService.cartItems.isNotEmpty
                              ? 'GO TO BAG (${mockService.cartItems.length})'
                              : 'GO TO BAG',
                          variant: AppButtonVariant.primary,
                          onPressed: _navigateToBag,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
