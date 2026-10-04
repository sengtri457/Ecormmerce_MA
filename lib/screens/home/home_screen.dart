import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/department_repository.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/trust_badges.dart';
import '../catalog/product_list_screen.dart';
import '../product/product_detail_screen.dart';
import 'widgets/department_category_grid.dart';
import 'widgets/department_promo_banner.dart';
import 'widgets/department_tab_bar.dart';
import 'widgets/editorial_lookbook_card.dart';
import 'widgets/home_hero_carousel.dart';
import 'widgets/home_section_header.dart';
import 'widgets/product_horizontal_list.dart';

/// The central Home Screen orchestrator.
/// High-level declarative layout composing isolated, reusable subcomponents.
class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  String _selectedGender = 'home';

  final DepartmentRepository _deptRepo = DepartmentRepository();
  final MockDataService _mockService = MockDataService();

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  void _onDepartmentSelected(String deptId) {
    setState(() {
      _selectedGender = deptId;
      _currentCarouselIndex = 0;
    });
    if (_carouselController.hasClients) {
      _carouselController.jumpToPage(0);
    }
  }

  void _navigateToCatalog({required String title, required String slug}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListScreen(categorySlug: slug, categoryTitle: title),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final department = _deptRepo.getContent(_selectedGender);
    final allProducts = _mockService.products;
    final allCategories = _mockService.categories;

    final bool isHomeTab = _selectedGender == 'home';
    final bool isAccessoryTab = _selectedGender == 'accessory';

    // Filter products for the selected department
    final List<Product> displayProducts;
    final List<Product> trendingProducts;

    if (isHomeTab) {
      // Home tab features the entire store flagship curated products
      displayProducts = allProducts;
      trendingProducts = allProducts.reversed.toList();
    } else if (isAccessoryTab) {
      // Accessory department filters for bags, jewelry, leather
      final accProds = allProducts
          .where(
            (p) =>
                p.category.toLowerCase() == 'accessory' ||
                p.subcategory.toLowerCase().contains('bag'),
          )
          .toList();
      displayProducts = accProds.isNotEmpty ? accProds : allProducts;
      trendingProducts = displayProducts.reversed.toList();
    } else {
      final deptProducts = allProducts
          .where(
            (p) => p.category.toLowerCase() == _selectedGender.toLowerCase(),
          )
          .toList();
      displayProducts = deptProducts.isNotEmpty ? deptProducts : allProducts;
      trendingProducts = displayProducts.reversed.toList();
    }

    // Active category for subcategories
    final CategoryItem? activeCategory = isHomeTab
        ? allCategories.firstOrNull
        : (isAccessoryTab
              ? allCategories
                    .where(
                      (c) => c.slug.contains('bag') || c.slug.contains('women'),
                    )
                    .firstOrNull
              : allCategories
                    .where(
                      (c) =>
                          c.slug.toLowerCase() == _selectedGender.toLowerCase(),
                    )
                    .firstOrNull);

    final String activeCategoryTitle = isHomeTab
        ? 'FEATURED CATEGORIES'
        : (isAccessoryTab
              ? 'ACCESSORY STYLES'
              : (activeCategory?.name ?? _selectedGender.toUpperCase()));
    final List<Subcategory> subcategories =
        activeCategory?.subcategories ?? const [];

    // Dynamic titles
    final String newArrivalsTitle = isHomeTab
        ? 'NEW ARRIVALS IN STORE'
        : (isAccessoryTab
              ? 'NEW IN ACCESSORIES'
              : 'NEW IN ${_selectedGender.toUpperCase()}');

    final String trendingTitle = isHomeTab
        ? 'TRENDING NOW'
        : (isAccessoryTab
              ? 'TRENDING ACCESSORIES'
              : 'TRENDING IN ${_selectedGender.toUpperCase()}');

    final String categoriesTitle = isHomeTab
        ? 'EXPLORE CATEGORIES'
        : (isAccessoryTab
              ? 'ACCESSORY CATEGORIES'
              : '${_selectedGender.toUpperCase()} CATEGORIES');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.search, color: AppColors.black, size: 22),
          onPressed: () => _navigateToCatalog(
            title: isHomeTab
                ? 'Search Store'
                : 'Search ${_selectedGender.toUpperCase()}',
            slug: isHomeTab ? 'all' : _selectedGender,
          ),
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
              Icons.shopping_bag_outlined,
              color: AppColors.black,
              size: 22,
            ),
            onPressed: () => widget.onNavigateTab(4),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Department Tabs
            DepartmentTabBar(
              selectedDepartmentId: _selectedGender,
              onDepartmentSelected: _onDepartmentSelected,
            ),

            // 2. Department Hero Carousel
            const SizedBox(height: 14),
            HomeHeroCarousel(
              controller: _carouselController,
              slides: department.slides,
              currentIndex: _currentCarouselIndex,
              promoColor: department.promoBox.color,
              onPageChanged: (idx) =>
                  setState(() => _currentCarouselIndex = idx),
              onSlideTap: (slide) => _navigateToCatalog(
                title: slide.category,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),

            // 3. New Arrivals Horizontal Feed
            const SizedBox(height: 24),
            HomeSectionHeader(
              title: newArrivalsTitle,
              subtitle:
                  'Headplacket daily from the world best brands and boutiques',
              actionText: 'SWIPE TO VIEW',
              onActionTap: () => _navigateToCatalog(
                title: newArrivalsTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            const SizedBox(height: 12),
            ProductHorizontalList(
              products: displayProducts,
              onProductTap: _navigateToProductDetail,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton.outlined(
                text: 'Shop Now',
                onPressed: () => _navigateToCatalog(
                  title: newArrivalsTitle,
                  slug: isHomeTab ? 'all' : _selectedGender,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Split Promo Banner
            DepartmentPromoBanner(
              promo: department.promoBox,
              onTap: () => _navigateToCatalog(
                title: isHomeTab
                    ? 'Flagship Sale'
                    : '${_selectedGender.toUpperCase()} Sale',
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),

            // 5. Trending Products Horizontal Feed
            HomeSectionHeader(
              title: trendingTitle,
              actionText: 'VIEW ALL',
              onActionTap: () => _navigateToCatalog(
                title: trendingTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            const SizedBox(height: 12),
            ProductHorizontalList(
              products: trendingProducts,
              onProductTap: _navigateToProductDetail,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton.outlined(
                text: 'Shop Now',
                onPressed: () => _navigateToCatalog(
                  title: trendingTitle,
                  slug: isHomeTab ? 'all' : _selectedGender,
                ),
              ),
            ),

            // 6. Subcategory Grid
            const SizedBox(height: 20),
            HomeSectionHeader(
              title: categoriesTitle,
              actionText: 'EXPLORE',
              onActionTap: () => _navigateToCatalog(
                title: activeCategoryTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            const SizedBox(height: 12),
            DepartmentCategoryGrid(
              subcategories: subcategories,
              onSubCategoryTap: (sub) => _navigateToCatalog(
                title: sub.name,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),

            // 7. Editorial Lookbook Card
            EditorialLookbookCard(
              lookbook: department.lookbook,
              onViewLookbook: () => _navigateToCatalog(
                title: department.lookbook.categoryTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),

            // 8. Trust Badges
            const SizedBox(height: 36),
            const TrustBadges(),
          ],
        ),
      ),
    );
  }
}
