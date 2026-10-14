import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/department_repository.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/trust_badges.dart';
import '../catalog/product_list_screen.dart';
import '../product/product_detail_screen.dart';
import 'widgets/category_horizontal_list.dart';
import 'widgets/department_category_grid.dart';
import 'widgets/department_promo_banner.dart';
import 'widgets/department_tab_bar.dart';
import 'widgets/editorial_lookbook_card.dart';
import 'widgets/home_hero_carousel.dart';
import 'widgets/home_section_header.dart';
import 'widgets/product_horizontal_list.dart';

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
    final fp = _mockService.featureProducts;

    final bool isHomeTab = _selectedGender == 'home';
    final bool isAccessoryTab = _selectedGender == 'accessory';

    // Filter products for the selected department
    final List<Product> displayProducts;
    final List<Product> trendingProducts;
    // ignore: unused_local_variable
    final List<Product> featuredProducts;

    if (isHomeTab) {
      displayProducts = (fp != null && fp.exclusiveOffers.isNotEmpty)
          ? fp.exclusiveOffers
          : allProducts;
      trendingProducts = (fp != null && fp.bestSellings.isNotEmpty)
          ? fp.bestSellings
          : allProducts.reversed.toList();
      featuredProducts = (fp != null && fp.features.isNotEmpty)
          ? fp.features
          : allProducts.where((p) => p.isFeatured).toList();
    } else if (isAccessoryTab) {
      final accProds = allProducts
          .where(
            (p) =>
                p.category.toLowerCase() == 'accessory' ||
                p.subcategory.toLowerCase().contains('bag'),
          )
          .toList();
      displayProducts = accProds.isNotEmpty ? accProds : allProducts;
      trendingProducts = displayProducts.reversed.toList();
      featuredProducts = const [];
    } else {
      final deptProducts = allProducts
          .where(
            (p) => p.category.toLowerCase() == _selectedGender.toLowerCase(),
          )
          .toList();
      displayProducts = deptProducts.isNotEmpty ? deptProducts : allProducts;
      trendingProducts = displayProducts.reversed.toList();
      featuredProducts = const [];
    }

    // Active category for subcategories
    final List<Subcategory> subcategories;
    final String activeCategoryTitle;

    if (isHomeTab) {
      activeCategoryTitle = 'FEATURED CATEGORIES';
      // Curate a vibrant selection of cross-store styles for the flagship Home tab
      subcategories = [
        Subcategory(id: 'disc', name: 'Discount', count: 120),
        Subcategory(id: 'tees', name: 'T-shirt', count: 85),
        Subcategory(id: 'hoodies', name: 'Hoodie', count: 64),
        Subcategory(id: 'hats', name: 'Hat', count: 36),
        Subcategory(id: 'dresses', name: 'Dresses', count: 68),
        Subcategory(id: 'coats', name: 'Jackets', count: 42),
        Subcategory(id: 'shoes', name: 'Shoes', count: 48),
        Subcategory(id: 'bags', name: 'Bags', count: 40),
      ];
    } else if (isAccessoryTab) {
      activeCategoryTitle = 'ACCESSORY STYLES';
      final cat = allCategories
          .where((c) => c.slug.contains('bag') || c.slug.contains('women'))
          .firstOrNull;
      subcategories = cat?.subcategories ?? const [];
    } else {
      final cat = allCategories
          .where((c) => c.slug.toLowerCase() == _selectedGender.toLowerCase())
          .firstOrNull;
      activeCategoryTitle = cat?.name ?? _selectedGender.toUpperCase();
      subcategories = cat?.subcategories ?? const [];
    }

    // Dynamic titles
    final String newArrivalsTitle = isHomeTab
        ? (fp?.exclusiveOffersTitle ?? 'EXCLUSIVE OFFERS')
        : (isAccessoryTab
              ? 'NEW IN ACCESSORIES'
              : 'NEW IN ${_selectedGender.toUpperCase()}');

    final String trendingTitle = isHomeTab
        ? (fp?.bestSellingsTitle ?? 'BEST SELLING')
        : (isAccessoryTab
              ? 'TRENDING ACCESSORIES'
              : 'TRENDING IN ${_selectedGender.toUpperCase()}');

    final String categoriesTitle = isHomeTab
        ? (fp?.featuresTitle ?? 'EXPLORE CATEGORIES')
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
            const SizedBox(height: AppSpacing.md),
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

            // 3. Category Horizontal Scroll with Emojis (Placed right after Slide)
            if (subcategories.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              CategoryHorizontalList(
                subcategories: subcategories,
                onSubCategoryTap: (sub) => _navigateToCatalog(
                  title: sub.name,
                  slug: isHomeTab ? 'all' : _selectedGender,
                ),
              ),
            ],

            // 4. New Arrivals Horizontal Feed
            _buildProductSection(
              title: newArrivalsTitle,
              subtitle:
                  'Handpicked daily from the world\'s finest ateliers and boutiques',
              actionText: 'VIEW ALL',
              products: displayProducts,
              onActionTap: () => _navigateToCatalog(
                title: newArrivalsTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // 5. Split Promo Banner
            DepartmentPromoBanner(
              promo: department.promoBox,
              onTap: () => _navigateToCatalog(
                title: isHomeTab
                    ? 'Flagship Sale'
                    : '${_selectedGender.toUpperCase()} Sale',
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            // 6. Trending Products Horizontal Feed
            _buildProductSection(
              title: trendingTitle,
              actionText: 'VIEW ALL',
              products: trendingProducts,
              onActionTap: () => _navigateToCatalog(
                title: trendingTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            // 7. Subcategory Grid
            const SizedBox(height: AppSpacing.xxl),
            HomeSectionHeader(
              title: categoriesTitle,
              actionText: 'EXPLORE',
              onActionTap: () => _navigateToCatalog(
                title: activeCategoryTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DepartmentCategoryGrid(
              subcategories: subcategories,
              onSubCategoryTap: (sub) => _navigateToCatalog(
                title: sub.name,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            // 8. Editorial Lookbook Card
            EditorialLookbookCard(
              lookbook: department.lookbook,
              onViewLookbook: () => _navigateToCatalog(
                title: department.lookbook.categoryTitle,
                slug: isHomeTab ? 'all' : _selectedGender,
              ),
            ),
            // 9. Trust Badges
            const SizedBox(height: AppSpacing.xxxl),
            const TrustBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection({
    required String title,
    String? subtitle,
    required String actionText,
    required List<Product> products,
    required VoidCallback onActionTap,
  }) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        HomeSectionHeader(
          title: title,
          subtitle: subtitle,
          actionText: actionText,
          onActionTap: onActionTap,
        ),
        const SizedBox(height: 12),
        ProductHorizontalList(
          products: products,
          onProductTap: _navigateToProductDetail,
        ),
      ],
    );
  }
}
