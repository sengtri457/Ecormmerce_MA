import 'dart:ui';
import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';
import '../helpers/app_dimensions.dart';
import '../models/menu_item.dart';

class GlassFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int bagBadgeCount;
  final int wishlistBadgeCount;
  final List<MenuItem>? items;

  const GlassFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.bagBadgeCount = 0,
    this.wishlistBadgeCount = 0,
    this.items,
  });

  static List<MenuItem> get defaultMenuItems => [
    MenuItem(label: 'Home', icon: 'assets/icons/home.png'),
    MenuItem(label: 'Category', icon: 'assets/icons/category.png'),
    MenuItem(label: 'Favorite', icon: 'assets/icons/favorite.png'),
    MenuItem(label: 'Account', icon: 'assets/icons/account.png'),
    MenuItem(label: 'Bag', icon: 'assets/icons/whishlist.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? defaultMenuItems;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.md,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.8),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  int badgeCount = 0;
                  final lowerLabel = item.label.toLowerCase();
                  if (index == 2 || lowerLabel.contains('fav') || lowerLabel.contains('wish')) {
                    badgeCount = wishlistBadgeCount;
                  } else if (index == 4 || lowerLabel.contains('bag') || lowerLabel.contains('cart')) {
                    badgeCount = bagBadgeCount;
                  }
                  return _navItem(
                    index: index,
                    item: item,
                    badgeCount: badgeCount,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required MenuItem item,
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;

    Widget iconWidget = Image.asset(
      item.icon,
      width: 22,
      height: 22,
      color: isSelected ? AppColors.white : AppColors.black,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.circle,
          size: 20,
          color: isSelected ? AppColors.white : AppColors.black,
        );
      },
    );

    if (badgeCount > 0) {
      final badgeText = badgeCount > 99 ? '99+' : '$badgeCount';
      iconWidget = Badge(
        label: Text(
          badgeText,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.saleRed,
        child: iconWidget,
      );
    }

    return Semantics(
      label: item.label,
      button: true,
      selected: isSelected,
      child: Tooltip(
        message: item.label,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: isSelected
                ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.activeNav : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.circular),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.activeNav.withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: iconWidget,
          ),
        ),
      ),
    );
  }
}
