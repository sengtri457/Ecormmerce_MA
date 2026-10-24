import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/banner_item.dart';
import '../models/category_item.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/user_profile.dart';
import 'home_service.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<CategoryItem> getCategoriesForDepartment(String department) {
    final dept = department.toLowerCase().trim();
    return categories.where((c) => c.department.toLowerCase() == dept).toList();
  }

  List<OnboardingItem> onboardingItems = [];
  List<CategoryBannerItem> categoryBanners = [];
  List<CategoryItem> categories = [];
  List<Product> products = [];
  FeatureProduct? featureProducts;
  List<CartItem> cartItems = [];
  Set<int> wishlistProductIds = {1, 5};
  UserProfile? userProfile;
  bool isLoggedIn = false;
  ShippingAddress? shippingAddress;
  String promoCode = 'FIRST20';
  double discountAmount = 50.00;
  double shippingFee = 15.00;

  final Map<int, double> _userRatings = {};
  final Map<int, double> _averageRatings = {};
  final Map<int, int> _reviewCounts = {};

  double? getUserRating(int productId) => _userRatings[productId];
  double? getAverageRating(int productId) => _averageRatings[productId];
  int? getReviewCount(int productId) => _reviewCounts[productId];

  double getDisplayRating(int productId, double defaultRating) =>
      _userRatings[productId] ?? _averageRatings[productId] ?? defaultRating;

  int getDisplayReviewCount(int productId, int defaultCount) =>
      _reviewCounts[productId] ?? defaultCount;

  Future<void> initialize() async {
    if (_isLoaded) return;
    try {
      const homeService = HomeService();
      onboardingItems = await homeService.getOnboardingItems();
      categoryBanners = await homeService.getCategoryBanners();
      categories = await homeService.getCategories();
      products = await homeService.getProducts();
      featureProducts = await homeService.getFeatureProducts();

      final cartString = await HomeService.loadString('assets/json/cart.json');
      final cartJson = json.decode(cartString) as Map<String, dynamic>;
      final rawCart = cartJson['items'] as List? ?? const [];
      cartItems = rawCart
          .whereType<Map<String, dynamic>>()
          .map((x) => CartItem.fromJson(x))
          .toList();
      if (cartJson['shippingAddress'] != null &&
          cartJson['shippingAddress'] is Map<String, dynamic>) {
        shippingAddress = ShippingAddress.fromJson(
          cartJson['shippingAddress'] as Map<String, dynamic>,
        );
      }
      promoCode = cartJson['promoCode'] as String? ?? 'FIRST20';
      discountAmount = (cartJson['discountAmount'] as num?)?.toDouble() ?? 50.0;
      shippingFee = (cartJson['shippingFee'] as num?)?.toDouble() ?? 15.0;

      final profileString = await HomeService.loadString(
        'assets/json/user_profile.json',
      );
      final profileJson = json.decode(profileString) as Map<String, dynamic>;
      userProfile = UserProfile.fromJson(profileJson);

      _isLoaded = true;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('MockDataService initialization error: $e\n$stackTrace');
    }
  }

  List<CartItem> get selectedCartItems =>
      cartItems.where((item) => item.isSelected).toList();

  int get selectedCartCount => selectedCartItems.length;

  bool get isAllCartSelected =>
      cartItems.isNotEmpty && cartItems.every((item) => item.isSelected);

  void toggleCartItemSelection(String cartItemId, [bool? isSelected]) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      cartItems[index].isSelected = isSelected ?? !cartItems[index].isSelected;
      notifyListeners();
    }
  }

  dynamic selectAllCartItems(bool isSelected) {
    for (final item in cartItems) {
      item.isSelected = isSelected;
    }
    notifyListeners();
  }

  double get cartSubtotal => selectedCartItems.fold(
    0.0,
    (sum, item) => sum + (item.price * item.quantity),
  );

  double get effectiveShippingFee =>
      selectedCartItems.isEmpty ? 0.0 : shippingFee;
  double get effectiveDiscountAmount {
    if (selectedCartItems.isEmpty) return 0.0;
    final discount = promoCode == 'VIP10'
        ? cartSubtotal * 0.10
        : discountAmount;
    return discount > cartSubtotal ? cartSubtotal : discount;
  }

  double get cartTotal {
    if (selectedCartItems.isEmpty) return 0.0;
    final total = cartSubtotal + effectiveShippingFee - effectiveDiscountAmount;
    return total > 0 ? total : 0.0;
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'FIRST20') {
      promoCode = 'FIRST20';
      discountAmount = 20.00;
      notifyListeners();
      return true;
    } else if (cleanCode == 'VIP10') {
      promoCode = 'VIP10';
      notifyListeners();
      return true;
    } else if (cleanCode == 'SAVE100' && cartSubtotal >= 300) {
      promoCode = 'SAVE100';
      discountAmount = 100.00;
      notifyListeners();
      return true;
    }
    return false;
  }

  void addToCart(
    Product product, {
    required String color,
    required String size,
    int quantity = 1,
  }) {
    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.productId == product.id &&
          item.color == color &&
          item.size == size,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          title: product.title,
          brand: product.brand,
          price: product.price,
          originalPrice: product.originalPrice,
          color: color,
          size: size,
          quantity: quantity,
          imageUrl: product.images.isNotEmpty ? product.images.first : '',
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int delta) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final newQty = cartItems[index].quantity + delta;
      if (newQty > 0) {
        cartItems[index].quantity = newQty;
      } else {
        cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void setCartQuantity(String cartItemId, int quantity) {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (quantity > 0) {
        cartItems[index].quantity = quantity;
      } else {
        cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void moveToWishlist(String cartItemId) {
    final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);
    if (itemIndex != -1) {
      final item = cartItems[itemIndex];
      wishlistProductIds.add(item.productId);
      cartItems.removeAt(itemIndex);
      notifyListeners();
    }
  }

  void clearSelectedCart() {
    cartItems.removeWhere((item) => item.isSelected);
    notifyListeners();
  }

  void login({UserProfile? profile}) {
    isLoggedIn = true;
    if (profile != null) userProfile = profile;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  int get wishlistCount => wishlistProductIds.length;

  bool isFavorite(int productId) => wishlistProductIds.contains(productId);

  void toggleFavorite(int productId) {
    if (wishlistProductIds.contains(productId)) {
      wishlistProductIds.remove(productId);
    } else {
      wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> get wishlistProducts {
    return products.where((p) => wishlistProductIds.contains(p.id)).toList();
  }

  Product? getProductById(int productId) {
    Product? found;
    try {
      found = products.firstWhere((p) => p.id == productId);
    } catch (_) {
      if (featureProducts != null) {
        for (final p in [
          ...featureProducts!.exclusiveOffers,
          ...featureProducts!.bestSellings,
          ...featureProducts!.features,
        ]) {
          if (p.id == productId) {
            found = p;
            break;
          }
        }
      }
    }
    if (found != null && _userRatings.containsKey(productId)) {
      return found.copyWith(
        rating: _averageRatings[productId] ?? found.rating,
        reviewCount: _reviewCounts[productId] ?? found.reviewCount,
        userRating: _userRatings[productId],
      );
    }
    return found;
  }

  Product rateProduct(
    int productId,
    double userRating, [
    Product? fallbackProduct,
  ]) {
    final clampedRating = userRating.clamp(1.0, 5.0);

    // Look up current product to compute running average
    Product? base;
    try {
      base = products.firstWhere((p) => p.id == productId);
    } catch (_) {
      base = fallbackProduct;
    }

    final currentAverage = _averageRatings[productId] ?? base?.rating ?? 5.0;
    final currentCount = _reviewCounts[productId] ?? base?.reviewCount ?? 0;
    final oldUserRating = _userRatings[productId] ?? base?.userRating;

    double newAverage;
    int newCount;

    if (oldUserRating != null) {
      final totalScore =
          (currentAverage * currentCount) - oldUserRating + clampedRating;
      newCount = currentCount;
      newAverage = newCount > 0 ? (totalScore / newCount) : clampedRating;
    } else {
      final totalScore = (currentAverage * currentCount) + clampedRating;
      newCount = currentCount + 1;
      newAverage = totalScore / newCount;
    }

    final roundedRating = double.parse(newAverage.toStringAsFixed(1));

    // Save strictly to rating maps
    _userRatings[productId] = clampedRating;
    _averageRatings[productId] = roundedRating;
    _reviewCounts[productId] = newCount;

    // In-place update of rating fields ONLY (never touches images or other attributes)
    Product updateOnlyRating(Product p) {
      if (p.id != productId) return p;
      return p.copyWith(
        rating: roundedRating,
        reviewCount: newCount,
        userRating: clampedRating,
      );
    }

    products = products.map(updateOnlyRating).toList();

    if (featureProducts != null) {
      featureProducts = FeatureProduct(
        exclusiveOffersTitle: featureProducts!.exclusiveOffersTitle,
        bestSellingsTitle: featureProducts!.bestSellingsTitle,
        featuresTitle: featureProducts!.featuresTitle,
        exclusiveOffers: featureProducts!.exclusiveOffers
            .map(updateOnlyRating)
            .toList(),
        bestSellings: featureProducts!.bestSellings
            .map(updateOnlyRating)
            .toList(),
        features: featureProducts!.features.map(updateOnlyRating).toList(),
      );
    }

    notifyListeners();

    return (base ?? fallbackProduct)?.copyWith(
          rating: roundedRating,
          reviewCount: newCount,
          userRating: clampedRating,
        ) ??
        Product(
          id: productId,
          title: '',
          brand: '',
          category: '',
          subcategory: '',
          price: 0,
          originalPrice: 0,
          discountPercent: 0,
          rating: roundedRating,
          reviewCount: newCount,
          userRating: clampedRating,
          isNew: false,
          isFeatured: false,
          description: '',
          material: '',
          care: '',
          colors: [],
          sizes: [],
          images: [],
        );
  }

  Future<List<CategoryItem>> loadCategoryProducts() async {
    if (categories.isNotEmpty) return categories;
    const homeService = HomeService();
    categories = await homeService.getCategories();
    notifyListeners();
    return categories;
  }
}
