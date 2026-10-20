import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../models/category_item.dart';
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
  String _selectedDepartment = 'women';
  final List<String> _departments = const ['WOMEN', 'MEN', 'KIDS'];

  @override
  void initState() {
    super.initState();
    if (MockDataService().visualCategories.isEmpty) {
      MockDataService().loadCategoryProducts();
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _navigateToCatalog({
    required String slug,
    required String title,
    String? subcategory,
    String? pillar,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          categorySlug: slug,
          categoryTitle: title,
          initialSubcategory: subcategory,
          initialPillar: pillar,
        ),
      ),
    );
  }

  void _openFilter() {
    final mockService = MockDataService();
    final currentDeptCategories = mockService.getCategoriesForDepartment(
      _selectedDepartment,
    );
    final categoryNames = currentDeptCategories.isNotEmpty
        ? currentDeptCategories.map((c) => c.title).toList()
        : const ['CLOTHES', 'SHOES', 'ACCESSORIES'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialPrice: const RangeValues(0, 600),
        initialCategory: _selectedDepartment.toUpperCase(),
        initialSize: null,
        availableCategories: categoryNames,
        onApply: (priceRange, category, size) {
          _navigateToCatalog(
            slug: _selectedDepartment,
            title: '${_selectedDepartment.toUpperCase()} Filtered',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

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
            ListenableBuilder(
              listenable: mockService,
              builder: (context, _) {
                final bagCount = mockService.cartItems.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.black,
                        size: 22,
                      ),
                      tooltip: 'Shopping Bag',
                      onPressed: widget.onNavigateToBag,
                    ),
                    if (bagCount > 0)
                      Positioned(
                        top: 10,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.alertRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Center(
                            child: Text(
                              '$bagCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
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
            final categories = mockService.getCategoriesForDepartment(
              _selectedDepartment,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Department Segment Switcher
                  _buildDepartmentSwitcher(),

                  const SizedBox(height: 20),

                  // Header with Title and List/Grid toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CATEGORY',
                            style: AppTypography.headingLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_selectedDepartment.toUpperCase()} • 3 CURATED PILLARS',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() => _isGridView = false),
                            borderRadius: BorderRadius.circular(4),
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
                            borderRadius: BorderRadius.circular(4),
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

                  const SizedBox(height: 18),

                  // Content: List Mode or Symmetrical 2x2 Grid Mode
                  if (!_isGridView)
                    _buildPillarsList(categories)
                  else
                    _buildPillarsGrid(categories),

                  const SizedBox(height: 28),

                  // Editorial Promo Lookbook Box
                  _buildPromoBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDepartmentSwitcher() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: Row(
        children: _departments.map((dept) {
          final isSelected = _selectedDepartment == dept.toLowerCase();
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDepartment = dept.toLowerCase();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      width: 2.2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    dept,
                    style: AppTypography.headingSmall.copyWith(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      letterSpacing: 2.0,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPillarsList(List<CategoryItem> categories) {
    return Column(
      children: categories.map((cat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner Image
              InkWell(
                onTap: () => _navigateToCatalog(
                  slug: _selectedDepartment,
                  title: '${_selectedDepartment.toUpperCase()} ${cat.title}',
                  pillar: cat.id,
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppImage(
                        imagePath: cat.image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.70),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 14,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.title,
                                  style: AppTypography.headingLarge.copyWith(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${cat.itemCount > 0 ? cat.itemCount : 40}+ ITEMS',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.85,
                                    ),
                                    fontSize: 10,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.5),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'VIEW ALL',
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 9,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Subcategory Quick Navigation Chips
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: cat.subcategories.map((sub) {
                    final subName = sub.name;
                    final isAll = subName.startsWith('All');
                    return InkWell(
                      onTap: () => _navigateToCatalog(
                        slug: _selectedDepartment,
                        title: subName,
                        subcategory: isAll ? null : subName,
                        pillar: cat.id,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAll ? AppColors.black : AppColors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isAll ? AppColors.black : AppColors.border,
                          ),
                        ),
                        child: Text(
                          subName,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: isAll
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isAll
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPillarsGrid(List<CategoryItem> categories) {
    // Symmetrical 2x2 layout: 3 Category Pillars + 1 Editorial New Arrival Card
    final cards = <Widget>[
      ...categories.take(3).map((cat) {
        return _buildGridCard(
          title: cat.title,
          subtitle: '${cat.itemCount > 0 ? cat.itemCount : 35}+ Items',
          image: cat.image,
          onTap: () => _navigateToCatalog(
            slug: _selectedDepartment,
            title: '${_selectedDepartment.toUpperCase()} ${cat.title}',
            pillar: cat.id,
          ),
        );
      }),
      _buildGridCard(
        title: 'NEW IN',
        subtitle: 'Curated SS26 Edit',
        image: 'assets/images/products/image1.jpg',
        badge: 'LIMITED',
        onTap: () => _navigateToCatalog(
          slug: _selectedDepartment,
          title: '${_selectedDepartment.toUpperCase()} New Arrivals',
        ),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }

  Widget _buildGridCard({
    required String title,
    required String subtitle,
    required String image,
    String? fallback,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              imagePath: image,
              fallbackUrl: fallback,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            if (badge != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.alertRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        children: [
          Text(
            'THE MINIMAL WARDROBE EDIT',
            style: AppTypography.headingSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
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
          const SizedBox(height: 16),
          AppButton.outlined(
            text: 'BROWSE PRODUCTS',
            uppercase: true,
            width: 220,
            height: 42,
            onPressed: () => _navigateToCatalog(
              slug: _selectedDepartment,
              title:
                  '${_selectedDepartment.toUpperCase()} - The Minimal Wardrobe Edit',
            ),
          ),
        ],
      ),
    );
  }
}
