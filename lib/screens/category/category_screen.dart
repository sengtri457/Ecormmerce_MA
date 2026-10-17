import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../models/category.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';
import '../catalog/filter_bottom_sheet.dart';
import '../catalog/product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  final VoidCallback? onNavigateToBag;
  final VoidCallback? onBack;

  const CategoryScreen({super.key, this.onNavigateToBag, this.onBack});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isGridView = false;
  List<VisualCategory> _visualCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final mockService = MockDataService();
    if (mockService.visualCategories.isNotEmpty) {
      if (mounted) {
        setState(() {
          _visualCategories = mockService.visualCategories;
          _isLoading = false;
        });
      }
      return;
    }

    final items = await mockService.loadCategoryProducts();
    if (mounted) {
      setState(() {
        _visualCategories = items;
        _isLoading = false;
      });
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _navigateToCategory(String slug, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListScreen(categorySlug: slug, categoryTitle: title),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.black,
              size: 18,
            ),
            tooltip: 'Back',
            onPressed: _handleBack,
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
              icon: const Icon(
                Icons.tune_outlined,
                color: AppColors.black,
                size: 22,
              ),
              tooltip: 'Filter',
              onPressed: _openFilter,
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.black,
                size: 22,
              ),
              tooltip: 'Shopping Bag',
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
                      InkWell(
                        onTap: () => setState(() => _isGridView = false),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: !_isGridView
                                ? AppColors.surfaceLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.crop_16_9_outlined,
                            size: 22,
                            color: !_isGridView
                                ? AppColors.black
                                : AppColors.placeholder,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => setState(() => _isGridView = true),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isGridView
                                ? AppColors.surfaceLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.grid_view_sharp,
                            size: 20,
                            color: _isGridView
                                ? AppColors.black
                                : AppColors.placeholder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: AppColors.black),
                  ),
                )
              else if (_visualCategories.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('No categories available'),
                  ),
                )
              else ...[
                if (!_isGridView)
                  _buildSingleColumnList()
                else
                  _buildTwoColumnGrid(),

                const SizedBox(height: 24),

                ..._visualCategories.map((cat) => _buildAccordionTile(cat)),

                const SizedBox(height: 28),

                _buildPromoBox(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumnList() {
    return Column(
      children: _visualCategories.map((cat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildBannerCard(
            title: cat.title,
            image: cat.image,
            fallback: cat.fallback,
            height: 145,
            onTap: () => _navigateToCategory(cat.id, cat.title),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTwoColumnGrid() {
    if (_visualCategories.isEmpty) return const SizedBox.shrink();
    if (_visualCategories.length == 1) {
      final single = _visualCategories.first;
      return _buildBannerCard(
        title: single.title,
        image: single.image,
        fallback: single.fallback,
        height: 145,
        onTap: () => _navigateToCategory(single.id, single.title),
      );
    }

    final catClothing = _visualCategories[0];
    final catShoes = _visualCategories[1];

    final remainingCards = <Widget>[];
    for (int i = 2; i < _visualCategories.length; i++) {
      final cat = _visualCategories[i];
      remainingCards.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _buildBannerCard(
            title: cat.title,
            image: cat.image,
            fallback: cat.fallback,
            height: 145,
            onTap: () => _navigateToCategory(cat.id, cat.title),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBannerCard(
                title: catClothing.title,
                image: catClothing.image,
                fallback: catClothing.fallback,
                height: 145,
                onTap: () =>
                    _navigateToCategory(catClothing.id, catClothing.title),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBannerCard(
                title: catShoes.title,
                image: catShoes.image,
                fallback: catShoes.fallback,
                height: 145,
                onTap: () => _navigateToCategory(catShoes.id, catShoes.title),
              ),
            ),
          ],
        ),
        ...remainingCards,
      ],
    );
  }

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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
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

  Widget _buildAccordionTile(VisualCategory cat) {
    final subcategories = cat.subcategories;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          title: Text(
            cat.title,
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
              onTap: () => _navigateToCategory(cat.id, sub),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
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
            onPressed: () =>
                _navigateToCategory('all', 'The Minimal Wardrobe Edit'),
          ),
        ],
      ),
    );
  }
}
