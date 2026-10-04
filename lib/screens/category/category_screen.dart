import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';
import '../catalog/filter_bottom_sheet.dart';
import '../catalog/product_list_screen.dart';

/// Interactive Category Hub screen matching the latest Figma specifications.
/// Supports single-column banner view and 2-column grid view switching,
/// interactive category accordion menus, and editorial campaign drops.
class CategoryScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBag;

  const CategoryScreen({super.key, this.onNavigateToBag});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // false = Single-column Card view (left mockup)
  // true  = 2-Column Grid view (right mockup)
  bool _isGridView = false;

  final List<Map<String, dynamic>> _visualCategories = [
    {
      'id': 'clothing',
      'title': 'CLOTHING',
      'image': 'assets/images/bannerMen.gif',
      'fallback': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=900&auto=format&fit=crop&q=80',
      'subcategories': [
        'All Clothing',
        'T-Shirts & Tops',
        'Hoodies & Sweatshirts',
        'Jackets & Coats',
        'Pants & Denim',
        'Knitwear & Sweaters',
      ],
    },
    {
      'id': 'shoes',
      'title': 'SHOES',
      'image': 'assets/images/products/image2.jpg',
      'fallback': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=900&auto=format&fit=crop&q=80',
      'subcategories': [
        'All Shoes',
        'Sneakers & Runners',
        'Boots & Derbies',
        'Loafers',
        'Slides & Sandals',
      ],
    },
    {
      'id': 'accessories',
      'title': 'ACCESSORIES',
      'image': 'assets/images/BannerWomen.avif',
      'fallback': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=900&auto=format&fit=crop&q=80',
      'subcategories': [
        'All Accessories',
        'Bags & Backpacks',
        'Belts & Small Leather',
        'Jewelry & Chains',
        'Eyewear & Sunglasses',
        'Hats & Beanies',
      ],
    },
  ];

  void _navigateToCategory(String slug, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          categorySlug: slug,
          categoryTitle: title,
        ),
      ),
    );
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialPrice: const RangeValues(0, 600),
        initialCategory: 'All',
        initialSize: null,
        onApply: (priceRange, category, size) {
          _navigateToCategory(category ?? 'all', 'Filtered Products');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.tune_outlined, color: AppColors.black, size: 22),
          onPressed: _openFilter,
        ),
        title: Image.asset(
          'assets/images/logoDevs.png',
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Text(
            'MA STUDIO',
            style: AppTypography.headingLarge.copyWith(
              fontSize: 22,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.black, size: 22),
            onPressed: widget.onNavigateToBag,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Title & View Toggle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CATEGORY',
                  style: AppTypography.headingLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  children: [
                    // Single column card view icon
                    InkWell(
                      onTap: () => setState(() => _isGridView = false),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: !_isGridView ? AppColors.surfaceLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.crop_16_9_outlined,
                          size: 22,
                          color: !_isGridView ? AppColors.black : AppColors.placeholder,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // 2-column grid view icon
                    InkWell(
                      onTap: () => setState(() => _isGridView = true),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isGridView ? AppColors.surfaceLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.grid_view_sharp,
                          size: 20,
                          color: _isGridView ? AppColors.black : AppColors.placeholder,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Visual Category Cards (List or Grid)
            if (!_isGridView)
              _buildSingleColumnList()
            else
              _buildTwoColumnGrid(),

            const SizedBox(height: 24),

            // 3. Category Accordion Expansion Tiles
            ..._visualCategories.map((cat) => _buildAccordionTile(cat)),

            const SizedBox(height: 28),

            // 4. Minimal Wardrobe Edit Promo Box
            _buildPromoBox(),
          ],
        ),
      ),
    );
  }

  /// Single-column view: 3 stacked full-width editorial cards
  Widget _buildSingleColumnList() {
    return Column(
      children: _visualCategories.map((cat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildBannerCard(
            title: cat['title'] as String,
            image: cat['image'] as String,
            fallback: cat['fallback'] as String,
            height: 145,
            onTap: () => _navigateToCategory(cat['id'] as String, cat['title'] as String),
          ),
        );
      }).toList(),
    );
  }

  /// 2-column grid view: Clothing & Shoes side-by-side, Accessories full-width below
  Widget _buildTwoColumnGrid() {
    final catClothing = _visualCategories[0];
    final catShoes = _visualCategories[1];
    final catAccessories = _visualCategories[2];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBannerCard(
                title: catClothing['title'] as String,
                image: catClothing['image'] as String,
                fallback: catClothing['fallback'] as String,
                height: 145,
                onTap: () => _navigateToCategory(catClothing['id'] as String, catClothing['title'] as String),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBannerCard(
                title: catShoes['title'] as String,
                image: catShoes['image'] as String,
                fallback: catShoes['fallback'] as String,
                height: 145,
                onTap: () => _navigateToCategory(catShoes['id'] as String, catShoes['title'] as String),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildBannerCard(
          title: catAccessories['title'] as String,
          image: catAccessories['image'] as String,
          fallback: catAccessories['fallback'] as String,
          height: 145,
          onTap: () => _navigateToCategory(catAccessories['id'] as String, catAccessories['title'] as String),
        ),
      ],
    );
  }

  /// Visual category card with dark gradient and bottom-left bold label
  Widget _buildBannerCard({
    required String title,
    required String image,
    required String fallback,
    required double height,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AppImage(
                imagePath: image,
                fallbackUrl: fallback,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(14),
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Expansion accordion tile showing subcategories on tap
  Widget _buildAccordionTile(Map<String, dynamic> cat) {
    final subcategories = (cat['subcategories'] as List).cast<String>();

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          title: Text(
            cat['title'] as String,
            style: AppTypography.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.black,
          collapsedIconColor: AppColors.black,
          children: subcategories.map((sub) {
            return InkWell(
              onTap: () => _navigateToCategory(cat['id'] as String, sub),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sub,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.placeholder,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Editorial promo box at the bottom
  Widget _buildPromoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'THE MINIMAL WARDROBE EDIT',
            style: AppTypography.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tactile natural fibers cut with architectural proportion and calm intent.',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          AppButton.outlined(
            text: 'BROWSE PRODUCTS',
            uppercase: true,
            width: 220,
            height: 42,
            onPressed: () => _navigateToCategory('all', 'The Minimal Wardrobe Edit'),
          ),
        ],
      ),
    );
  }
}
