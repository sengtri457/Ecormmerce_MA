import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_wireframe.dart';
import '../catalog/filter_bottom_sheet.dart';
import '../catalog/product_list_screen.dart';
import 'widgets/category_department_switcher.dart';
import 'widgets/category_pillar_card.dart';
import 'widgets/category_pillars_grid.dart';
import 'widgets/category_promo_banner.dart';

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
    if (MockDataService().categories.isEmpty) {
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
                  CategoryDepartmentSwitcher(
                    departments: _departments,
                    selectedDepartment: _selectedDepartment,
                    onDepartmentSelected: (dept) {
                      setState(() => _selectedDepartment = dept);
                    },
                  ),
                  const SizedBox(height: 20),
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
                  if (categories.isEmpty)
                    _buildWireframeContent()
                  else if (!_isGridView)
                    Column(
                      children: categories.map((cat) {
                        return CategoryPillarCard(
                          category: cat,
                          onTap: () => _navigateToCatalog(
                            slug: _selectedDepartment,
                            title: '${_selectedDepartment.toUpperCase()} ${cat.title}',
                            pillar: cat.id,
                          ),
                          onSubcategoryTap: (subName) {
                            final isAll = subName.startsWith('All');
                            _navigateToCatalog(
                              slug: _selectedDepartment,
                              title: subName,
                              subcategory: isAll ? null : subName,
                              pillar: cat.id,
                            );
                          },
                        );
                      }).toList(),
                    )
                  else
                    CategoryPillarsGrid(
                      categories: categories,
                      onCategoryTap: (cat) => _navigateToCatalog(
                        slug: _selectedDepartment,
                        title: '${_selectedDepartment.toUpperCase()} ${cat.title}',
                        pillar: cat.id,
                      ),
                      onNewInTap: () => _navigateToCatalog(
                        slug: _selectedDepartment,
                        title: '${_selectedDepartment.toUpperCase()} New Arrivals',
                      ),
                    ),
                  const SizedBox(height: 28),
                  CategoryPromoBanner(
                    onBrowse: () => _navigateToCatalog(
                      slug: _selectedDepartment,
                      title:
                          '${_selectedDepartment.toUpperCase()} - The Minimal Wardrobe Edit',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWireframeContent() {
    return Column(
      children: [
        AppWireframe.box(width: double.infinity, height: 110, borderRadius: AppRadius.md),
        const SizedBox(height: 14),
        AppWireframe.box(width: double.infinity, height: 110, borderRadius: AppRadius.md),
        const SizedBox(height: 14),
        AppWireframe.box(width: double.infinity, height: 110, borderRadius: AppRadius.md),
      ],
    );
  }
}
