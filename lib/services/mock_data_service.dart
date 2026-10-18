import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/banner_item.dart';
import '../models/category.dart';
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

  List<VisualCategory> getCategoriesForDepartment(String department) {
    final dept = department.toLowerCase().trim();
    return visualCategories
        .where((c) => c.department.toLowerCase() == dept)
        .toList();
  }

  List<OnboardingItem> onboardingItems = [];
  List<CategoryBannerItem> categoryBanners = [];
  List<CategoryItem> categories = [];
  List<VisualCategory> visualCategories = [];
  List<Product> products = [];
  FeatureProduct? featureProducts;
  List<CartItem> cartItems = [];
  Set<int> wishlistProductIds = {1, 5};
  UserProfile? userProfile;
  ShippingAddress? shippingAddress;
  String promoCode = 'FIRST20';
  double discountAmount = 50.00;
  double shippingFee = 15.00;

  Future<void> initialize() async {
    if (_isLoaded) return;
    try {
      const homeService = HomeService();
      onboardingItems = await homeService.getOnboardingItems();
      categoryBanners = await homeService.getCategoryBanners();
      categories = await homeService.getCategories();
      visualCategories = await homeService.getCategoryProducts();
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

  void selectAllCartItems(bool isSelected) {
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
    double discount = discountAmount;
    if (promoCode == 'VIP10') {
      discount = cartSubtotal * 0.10;
    }
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
      discountAmount = cartSubtotal * 0.10;
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

  Future<List<VisualCategory>> loadCategoryProducts() async {
    if (visualCategories.isNotEmpty) return visualCategories;
    const homeService = HomeService();
    visualCategories = await homeService.getCategoryProducts();
    notifyListeners();
    return visualCategories;
  }
}
