import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../widgets/glass_nav_bar.dart';
import 'bag/shopping_bag_screen.dart';
import 'category/category_screen.dart';
import 'home/home_screen.dart';
import 'profile/user_profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

    final screens = [
      HomeScreen(onNavigateTab: _onTabTapped),
      CategoryScreen(onNavigateToBag: () => _onTabTapped(4)),
      WishlistScreen(
        onNavigateToBag: () => _onTabTapped(4),
        onBack: () => _onTabTapped(0),
      ),
      const UserProfileScreen(),
      ShoppingBagScreen(
        onNavigateToWishlist: () => _onTabTapped(2),
        onBack: () => _onTabTapped(0),
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: mockService,
        builder: (context, _) {
          return GlassFloatingNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            bagBadgeCount: mockService.cartItems.length,
          );
        },
      ),
    );
  }
}
