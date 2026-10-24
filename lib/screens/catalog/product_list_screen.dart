import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../helpers/catalog_filter_helper.dart';
import '../../models/subcategory.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';
import 'filter_bottom_sheet.dart';
import 'widgets/catalog_empty_state.dart';
import 'widgets/catalog_toolbar.dart';

class ProductListScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryTitle;
  final String? initialSubcategory;
  final String? initialPillar;

  const ProductListScreen({
    super.key,
    this.categorySlug = 'women',
    this.categoryTitle = 'Women Collection',
    this.initialSubcategory,
    this.initialPillar,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  late String _selectedSubcategory;
  RangeValues _priceRange = const RangeValues(0, 600);
  String? _sizeFilter;

  @override
  void initState() {
    super.initState();
    _selectedSubcategory = widget.initialSubcategory ?? 'all';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet(List<String> availableCategories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialPrice: _priceRange,
        initialSize: _sizeFilter,
        availableCategories: availableCategories,
        onApply: (price, cat, size) {
          setState(() {
            _priceRange = price;
            _sizeFilter = size;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final allProducts = mockService.products;

    final String slug = widget.categorySlug.toLowerCase();
    final bool isGeneric =
        slug == 'all' ||
        slug == 'clothes' ||
        slug == 'clothing' ||
        slug == 'shoes' ||
        slug == 'accessories';

    final categoryProducts = allProducts.where((p) {
      if (isGeneric) {
        if (slug != 'all') {
          return CatalogFilterHelper.matchesPillar(p, slug);
        }
        return true;
      }
      return p.category.toLowerCase() == slug;
    }).toList();

    final Set<String> availableSubIds = categoryProducts
        .map((p) => p.subcategory)
        .where((s) => s.isNotEmpty)
        .toSet();

    final List<Subcategory> subcategories = [
      const Subcategory(id: 'all', name: 'All'),
      ...availableSubIds.map((subId) {
        final formatted = subId
            .replaceFirst(RegExp(r'^[a-z]_'), '')
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
            )
            .join(' ');
        return Subcategory(id: subId, name: formatted);
      }),
    ];

    final filtered = allProducts.where((p) {
      final matchesCategory = isGeneric
          ? (slug == 'all' ? true : CatalogFilterHelper.matchesPillar(p, slug))
          : p.category.toLowerCase() == slug;

      final matchesPillarConstraint =
          widget.initialPillar == null ||
          CatalogFilterHelper.matchesPillar(p, widget.initialPillar!.toLowerCase());

      final matchesSearch =
          _searchController.text.isEmpty ||
          p.title.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          p.brand.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesSub =
          _selectedSubcategory == 'all' ||
          p.subcategory.toLowerCase() == _selectedSubcategory.toLowerCase() ||
          p.subcategory.toLowerCase().contains(
            _selectedSubcategory.toLowerCase(),
          );

      final matchesPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;
      final matchesSize = _sizeFilter == null || p.sizes.contains(_sizeFilter);

      return matchesCategory &&
          matchesPillarConstraint &&
          matchesSearch &&
          matchesSub &&
          matchesPrice &&
          matchesSize;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle.toUpperCase(),
          style: AppTypography.headingSmall.copyWith(letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTypography.bodyMedium,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search collection, designer...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: subcategories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final sub = subcategories[index];
                final isSel = _selectedSubcategory == sub.id;
                return ChoiceChip(
                  label: Text(
                    sub.name,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSel ? AppColors.white : AppColors.textPrimary,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppColors.black,
                  checkmarkColor: AppColors.white,
                  backgroundColor: AppColors.surfaceLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: isSel ? AppColors.black : AppColors.border,
                    ),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedSubcategory = sub.id);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          CatalogToolbar(
            itemCount: filtered.length,
            isGridView: _isGridView,
            onToggleView: () => setState(() => _isGridView = !_isGridView),
            onOpenFilter: () => _openFilterBottomSheet(
              subcategories.map((s) => s.name).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: filtered.isEmpty
                ? const CatalogEmptyState()
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 24,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 20,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final prod = filtered[index];
                          return ProductCard(
                            product: prod,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: prod),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 24,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final prod = filtered[index];
                          return ProductCard(
                            product: prod,
                            isHorizontal: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: prod),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
