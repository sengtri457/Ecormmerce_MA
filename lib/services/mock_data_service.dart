import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/banner_item.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/user_profile.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  List<OnboardingItem> onboardingItems = [];
  List<HomeBannerItem> heroBanners = [];
  List<PromoOffer> promoOffers = [];
  List<CategoryItem> categories = [];
  List<Product> products = [];
  List<CartItem> cartItems = [];
  Set<String> wishlistProductIds = {'prod_w1', 'prod_m1'};
  UserProfile? userProfile;
  ShippingAddress? shippingAddress;
  String promoCode = 'FIRST20';
  double discountAmount = 50.00;
  double shippingFee = 15.00;

  Future<void> initialize() async {
    if (_isLoaded) return;
    try {
      // 1. Load Banners & Onboarding
      final bannersString = await rootBundle.loadString('assets/json/banners.json');
      final bannersJson = json.decode(bannersString) as Map<String, dynamic>;
      
      var rawOnboarding = bannersJson['onboarding'] as List? ?? [];
      onboardingItems = rawOnboarding.map((x) => OnboardingItem.fromJson(x as Map<String, dynamic>)).toList();

      var rawBanners = bannersJson['home_hero_banners'] as List? ?? [];
      heroBanners = rawBanners.map((x) => HomeBannerItem.fromJson(x as Map<String, dynamic>)).toList();

      var rawOffers = bannersJson['promo_offers'] as List? ?? [];
      promoOffers = rawOffers.map((x) => PromoOffer.fromJson(x as Map<String, dynamic>)).toList();

      // 2. Load Categories
      final catString = await rootBundle.loadString('assets/json/categories.json');
      final catJson = json.decode(catString) as List;
      categories = catJson.map((x) => CategoryItem.fromJson(x as Map<String, dynamic>)).toList();

      // 3. Load Products
      final prodString = await rootBundle.loadString('assets/json/products.json');
      final prodJson = json.decode(prodString) as List;
      products = prodJson.map((x) => Product.fromJson(x as Map<String, dynamic>)).toList();

      // 4. Load Cart
      final cartString = await rootBundle.loadString('assets/json/cart.json');
      final cartJson = json.decode(cartString) as Map<String, dynamic>;
      var rawCart = cartJson['items'] as List? ?? [];
      cartItems = rawCart.map((x) => CartItem.fromJson(x as Map<String, dynamic>)).toList();
      if (cartJson['shippingAddress'] != null) {
        shippingAddress = ShippingAddress.fromJson(cartJson['shippingAddress'] as Map<String, dynamic>);
      }
      promoCode = cartJson['promoCode'] as String? ?? 'FIRST20';
      discountAmount = (cartJson['discountAmount'] as num?)?.toDouble() ?? 50.0;
      shippingFee = (cartJson['shippingFee'] as num?)?.toDouble() ?? 15.0;

      // 5. Load User Profile
      final profileString = await rootBundle.loadString('assets/json/user_profile.json');
      final profileJson = json.decode(profileString) as Map<String, dynamic>;
      userProfile = UserProfile.fromJson(profileJson);

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading JSON mock data: $e');
    }
  }

  // --- Cart Actions ---
  double get cartSubtotal => cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get cartTotal {
    double total = cartSubtotal + shippingFee - discountAmount;
    return total > 0 ? total : 0;
  }

  void addToCart(Product product, {required String color, required String size, int quantity = 1}) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.productId == product.id && item.color == color && item.size == size,
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

  // --- Wishlist Actions ---
  bool isFavorite(String productId) => wishlistProductIds.contains(productId);

  void toggleFavorite(String productId) {
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
}
