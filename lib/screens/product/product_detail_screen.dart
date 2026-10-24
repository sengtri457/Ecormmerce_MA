import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../models/product.dart';
import '../../services/mock_data_service.dart';
import '../bag/shopping_bag_screen.dart';
import '../wishlist/widgets/size_picker_bottom_sheet.dart';
import 'size_guide_sheet.dart';
import 'widgets/product_accordion_section.dart';
import 'widgets/product_bottom_bar.dart';
import 'widgets/product_color_selector.dart';
import 'widgets/product_gallery_carousel.dart';
import 'widgets/product_header_info.dart';
import 'widgets/product_recommendations.dart';
import 'widgets/product_size_selector.dart';
import 'widgets/rate_product_bottom_sheet.dart';

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

  void _openSizePicker() async {
    final result = await SizePickerBottomSheet.show(
      context,
      product: widget.product,
      initialSize: _selectedSize,
      addToBagOnConfirm: false,
      confirmButtonText: 'SELECT SIZE',
    );
    if (result != null) {
      setState(() => _selectedSize = result);
    }
  }

  void _openRateBottomSheet(Product currentProduct) async {
    final result = await RateProductBottomSheet.show(
      context,
      product: currentProduct,
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for rating ${currentProduct.title}!'),
          backgroundColor: AppColors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
            child: const Text(
              'CLOSE',
              style: TextStyle(color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart(Product currentProduct) {
    MockDataService().addToCart(
      currentProduct,
      color: _selectedColor,
      size: _selectedSize,
      quantity: _quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added $_quantity x ${currentProduct.title} ($_selectedColor, $_selectedSize) to bag.',
        ),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW BAG',
          textColor: AppColors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShoppingBagScreen()),
            );
          },
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

    final bool isOneSize =
        widget.product.sizes.length == 1 &&
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
                  const SizedBox(height: AppSpacing.sm),
                  ProductGalleryCarousel(
                    product: widget.product,
                    images: images,
                  ),

                  ListenableBuilder(
                    listenable: mockService,
                    builder: (context, _) {
                      final liveProduct =
                          mockService.getProductById(widget.product.id) ??
                          widget.product;
                      return ProductHeaderInfo(
                        product: liveProduct,
                        onRateTap: () => _openRateBottomSheet(liveProduct),
                      );
                    },
                  ),

                  ProductColorSelector(
                    colors: widget.product.colors,
                    selectedColor: _selectedColor,
                    onColorSelected: (col) =>
                        setState(() => _selectedColor = col),
                  ),

                  ProductSizeSelector(
                    sizes: availableSizes,
                    selectedSize: _selectedSize,
                    isOneSize: isOneSize,
                    onSizeSelected: (size) =>
                        setState(() => _selectedSize = size),
                    onOpenSizeGuide: _openSizeGuide,
                    onOpenSizeSheet: _openSizePicker,
                  ),

                  ProductAccordionSection(
                    product: widget.product,
                    onOpenSizeGuide: _openSizeGuide,
                    onContactSupport: _contactSupport,
                  ),

                  ProductRecommendations(
                    currentProduct: widget.product,
                    recommendedProducts: recommendedProducts,
                  ),
                ],
              ),
            ),
          ),

          ProductBottomBar(
            quantity: _quantity,
            selectedSize: _selectedSize,
            isOneSize: isOneSize,
            onOpenSizePicker: _openSizePicker,
            onIncrement: () => setState(() => _quantity++),
            onDecrement: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
            onAddToBag: () {
              final liveProduct =
                  mockService.getProductById(widget.product.id) ??
                  widget.product;
              _handleAddToCart(liveProduct);
            },
          ),
        ],
      ),
    );
  }
}
