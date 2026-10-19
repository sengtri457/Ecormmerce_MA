import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_dimensions.dart';
import '../../helpers/app_typography.dart';
import '../../models/category_item.dart';
import '../../models/product.dart';
import '../../services/department_repository.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
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

  void _navigateToCatalog({
    required String title,
    required String slug,
    String? subcategory,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          categorySlug: slug,
          categoryTitle: title,
          initialSubcategory: subcategory,
        ),
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
    return ListenableBuilder(
      listenable: _mockService,
      builder: (context, _) {
        final department = _deptRepo.getContent(_selectedGender);
        final allProducts = _mockService.products;
        final allCategories = _mockService.categories;
        final fp = _mockService.featureProducts;

        final bool isHomeTab = _selectedGender == 'home';
        final bool isAccessoryTab = _selectedGender == 'accessory';

        final List<Product> displayProducts;
        final List<Product> trendingProducts;

        if (isHomeTab) {
          displayProducts = (fp != null && fp.exclusiveOffers.isNotEmpty)
              ? fp.exclusiveOffers
              : allProducts;
          trendingProducts = (fp != null && fp.bestSellings.isNotEmpty)
              ? fp.bestSellings
              : allProducts.reversed.toList();
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
        } else {
          final deptProducts = allProducts
              .where(
                (p) =>
                    p.category.toLowerCase() == _selectedGender.toLowerCase(),
              )
              .toList();
          displayProducts = deptProducts.isNotEmpty
              ? deptProducts
              : allProducts;
          trendingProducts = displayProducts.reversed.toList();
        }

        final List<Subcategory> subcategories;
        final String activeCategoryTitle;

        if (isHomeTab) {
          activeCategoryTitle = 'FEATURED CATEGORIES';
          final dynamicSubs = allCategories
              .expand((c) => c.subcategories)
              .where((s) => !s.id.endsWith('_all'))
              .toList();
          subcategories = dynamicSubs.isNotEmpty
              ? dynamicSubs.take(8).toList()
              : const [];
        } else if (isAccessoryTab) {
          activeCategoryTitle = 'ACCESSORY STYLES';
          final cat = allCategories
              .where(
                (c) =>
                    c.id == 'accessories' ||
                    c.slug.contains('bag') ||
                    c.slug.contains('women'),
              )
              .firstOrNull;
          subcategories = cat?.subcategories ?? const [];
        } else {
          final cat = allCategories
              .where(
                (c) =>
                    c.department.toLowerCase() ==
                        _selectedGender.toLowerCase() ||
                    c.slug.toLowerCase() == _selectedGender.toLowerCase(),
              )
              .firstOrNull;
          activeCategoryTitle = cat?.name ?? _selectedGender.toUpperCase();
          subcategories = cat?.subcategories ?? const [];
        }

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
                DepartmentTabBar(
                  selectedDepartmentId: _selectedGender,
                  onDepartmentSelected: _onDepartmentSelected,
                ),

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

                if (subcategories.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  CategoryHorizontalList(
                    department: _selectedGender,
                    onItemTap: (pill) => _navigateToCatalog(
                      title: pill.label,
                      slug: isHomeTab ? 'all' : _selectedGender,
                      subcategory: pill.id,
                    ),
                  ),
                ],

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
                const SizedBox(height: AppSpacing.lg),
                DepartmentPromoBanner(
                  promo: department.promoBox,
                  onTap: () => _navigateToCatalog(
                    title: isHomeTab
                        ? 'Flagship Sale'
                        : '${_selectedGender.toUpperCase()} Sale',
                    slug: isHomeTab ? 'all' : _selectedGender,
                  ),
                ),
                _buildProductSection(
                  title: trendingTitle,
                  actionText: 'VIEW ALL',
                  products: trendingProducts,
                  onActionTap: () => _navigateToCatalog(
                    title: trendingTitle,
                    slug: isHomeTab ? 'all' : _selectedGender,
                  ),
                ),
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
                  onBannerTap: (banner) => _navigateToCatalog(
                    title: banner.title,
                    slug: banner.slug,
                  ),
                ),
                EditorialLookbookCard(
                  lookbook: department.lookbook,
                  onViewLookbook: () => _navigateToCatalog(
                    title: department.lookbook.categoryTitle,
                    slug: isHomeTab ? 'all' : _selectedGender,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                const TrustBadges(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductSection({
    required String title,
    String? subtitle,
    required String actionText,
    required List<Product> products,
    required VoidCallback onActionTap,
    String buttonText = 'Shop Now',
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
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppButton.outlined(
            text: buttonText,
            onPressed: onActionTap,
            height: 44,
            uppercase: false,
          ),
        ),
      ],
    );
  }
}
