import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';
import 'filter_bottom_sheet.dart';

class ProductListScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryTitle;

  const ProductListScreen({
    super.key,
    this.categorySlug = 'women',
    this.categoryTitle = 'Women Collection',
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  String _selectedSubcategory = 'all';
  RangeValues _priceRange = const RangeValues(0, 600);
  String? _sizeFilter;

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final allProducts = mockService.products;

    // Derive active subcategories dynamically for this category
    final categoryProducts = allProducts.where((p) =>
      widget.categorySlug == 'all' || p.category.toLowerCase() == widget.categorySlug.toLowerCase(),
    ).toList();

    final Set<String> availableSubIds = categoryProducts.map((p) => p.subcategory).where((s) => s.isNotEmpty).toSet();

    final List<Map<String, String>> subcategories = [
      {'id': 'all', 'name': 'All'},
      ...availableSubIds.map((subId) {
        // Clean up format, e.g. "w_coats" -> "Coats", "m_tees" -> "Tees"
        final formatted = subId
            .replaceFirst(RegExp(r'^[a-z]_'), '')
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
        return {'id': subId, 'name': formatted};
      }),
    ];

    // Filter logic
    final filtered = allProducts.where((p) {
      final matchesCategory = widget.categorySlug == 'all' ||
          p.category.toLowerCase() == widget.categorySlug.toLowerCase();

      final matchesSearch = _searchController.text.isEmpty ||
          p.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesSub = _selectedSubcategory == 'all' || p.subcategory == _selectedSubcategory;
      final matchesPrice = p.price >= _priceRange.start && p.price <= _priceRange.end;
      final matchesSize = _sizeFilter == null || p.sizes.contains(_sizeFilter);

      return matchesCategory && matchesSearch && matchesSub && matchesPrice && matchesSize;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.black),
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
          // 1. Search Box
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
                  const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
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
                      icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ),

          // 2. Subcategory Pills
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: subcategories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final sub = subcategories[index];
                final isSel = _selectedSubcategory == sub['id'];
                return ChoiceChip(
                  label: Text(
                    sub['name']!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSel ? AppColors.white : AppColors.textPrimary,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppColors.black,
                  backgroundColor: AppColors.surfaceLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: isSel ? AppColors.black : AppColors.border),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedSubcategory = sub['id']!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // 3. Toolbar (Found Count, Filter button, Grid/List toggle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} ITEMS',
                  style: AppTypography.formLabel.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                Row(
                  children: [
                    // Layout Toggle
                    IconButton(
                      icon: Icon(
                        _isGridView ? Icons.view_agenda_outlined : Icons.grid_view,
                        size: 20,
                        color: AppColors.black,
                      ),
                      onPressed: () => setState(() => _isGridView = !_isGridView),
                    ),
                    const SizedBox(width: 4),
                    // Filter Action Button
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => FilterBottomSheet(
                            initialPrice: _priceRange,
                            initialSize: _sizeFilter,
                            onApply: (price, cat, size) {
                              setState(() {
                                _priceRange = price;
                                _sizeFilter = size;
                              });
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.tune, size: 16, color: AppColors.black),
                            const SizedBox(width: 6),
                            Text(
                              'FILTER',
                              style: AppTypography.badge.copyWith(letterSpacing: 0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // 4. Products View
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: AppColors.placeholder),
                        const SizedBox(height: 12),
                        Text('NO PRODUCTS MATCH YOUR FILTER', style: AppTypography.headingSmall),
                        const SizedBox(height: 6),
                        Text('Try resetting filters or adjusting search term.', style: AppTypography.bodySmall),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: prod)),
                              );
                            },
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final prod = filtered[index];
                          return ProductCard(
                            product: prod,
                            isHorizontal: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: prod)),
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
