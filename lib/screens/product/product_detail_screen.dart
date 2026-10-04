import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../models/product.dart';
import '../../services/mock_data_service.dart';
import 'size_guide_sheet.dart';
import 'widgets/product_accordion_section.dart';
import 'widgets/product_bottom_bar.dart';
import 'widgets/product_color_selector.dart';
import 'widgets/product_gallery_carousel.dart';
import 'widgets/product_header_info.dart';
import 'widgets/product_recommendations.dart';
import 'widgets/product_size_selector.dart';

/// Clean, high-performance Product Detail Screen.
/// Composes clean, decoupled subcomponents following design system best practices.
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _selectedColor;
  late String _selectedSize;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.product.colors.isNotEmpty
        ? widget.product.colors.first.name
        : 'Default';
    _selectedSize = widget.product.sizes.isNotEmpty
        ? widget.product.sizes.first
        : 'M';
  }

  void _openSizeGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SizeGuideSheet(),
    );
  }

  void _showSizeSelectorSheet(List<String> sizes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT SIZE',
                      style: AppTypography.headingSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _openSizeGuide();
                      },
                      child: Text(
                        'Size Guide',
                        style: AppTypography.bodySmall.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: sizes.map((size) {
                    final isSelected = _selectedSize == size;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedSize = size);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.black : AppColors.surfaceLight,
                          border: Border.all(
                            color: isSelected ? AppColors.black : AppColors.border,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          size,
                          style: AppTypography.badge.copyWith(
                            fontSize: 13,
                            color: isSelected ? AppColors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product link copied to clipboard.'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Customer Care',
          style: AppTypography.headingSmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Our client advisors are available Monday to Saturday, 9am - 8pm EST.\n\nEmail: concierge@mastudio.com\nTel: +1 (800) 555-0199',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: AppColors.black)),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart() {
    MockDataService().addToCart(
      widget.product,
      color: _selectedColor,
      size: _selectedSize,
      quantity: _quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $_quantity x ${widget.product.title} ($_selectedColor, $_selectedSize) to bag.',
        ),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW BAG',
          textColor: AppColors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final allProducts = mockService.products;
    final recommendedProducts = allProducts
        .where((p) => p.id != widget.product.id)
        .take(2)
        .toList();

    final List<String> images = widget.product.images.isNotEmpty
        ? widget.product.images
        : ['assets/images/bannerMen.gif'];

    final bool isOneSize = widget.product.sizes.length == 1 &&
        widget.product.sizes.first.toLowerCase() == 'one size';

    final List<String> availableSizes = widget.product.sizes.isNotEmpty
        ? widget.product.sizes
        : ['XS', 'S', 'M', 'L', 'XL'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 28,
            color: AppColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.title.toUpperCase(),
          style: AppTypography.headingSmall.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: AppColors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, size: 20, color: AppColors.black),
            onPressed: _shareProduct,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Gallery Carousel
                  const SizedBox(height: AppSpacing.sm),
                  ProductGalleryCarousel(
                    product: widget.product,
                    images: images,
                  ),

                  // 2. Header, Brand, Rating & Price
                  ProductHeaderInfo(product: widget.product),

                  // 3. Color Selector
                  ProductColorSelector(
                    colors: widget.product.colors,
                    selectedColor: _selectedColor,
                    onColorSelected: (col) => setState(() => _selectedColor = col),
                  ),

                  // 4. Size Selector
                  ProductSizeSelector(
                    sizes: availableSizes,
                    selectedSize: _selectedSize,
                    isOneSize: isOneSize,
                    onSizeSelected: (size) => setState(() => _selectedSize = size),
                    onOpenSizeGuide: _openSizeGuide,
                    onOpenSizeSheet: () => _showSizeSelectorSheet(availableSizes),
                  ),

                  // 5. Accordion Sections
                  ProductAccordionSection(
                    product: widget.product,
                    onOpenSizeGuide: _openSizeGuide,
                    onContactSupport: _contactSupport,
                  ),

                  // 6. Curated Recommendations
                  ProductRecommendations(
                    currentProduct: widget.product,
                    recommendedProducts: recommendedProducts,
                  ),
                ],
              ),
            ),
          ),

          // 7. Sticky Bottom Bar
          ProductBottomBar(
            quantity: _quantity,
            onIncrement: () => setState(() => _quantity++),
            onDecrement: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
            onAddToBag: _handleAddToCart,
          ),
        ],
      ),
    );
  }
}
