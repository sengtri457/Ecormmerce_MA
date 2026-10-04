import 'dart:ui';
import 'package:flutter/material.dart';
import '../helpers/app_colors.dart';

class GlassFloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int bagBadgeCount;

  const GlassFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.bagBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    outlineIcon: Icons.home_outlined,
                  ),
                  _navItem(
                    index: 1,
                    icon: Icons.grid_view_rounded,
                    outlineIcon: Icons.grid_view,
                  ),
                  _navItem(
                    index: 2,
                    icon: Icons.favorite_rounded,
                    outlineIcon: Icons.favorite_border_rounded,
                  ),
                  _navItem(
                    index: 3,
                    icon: Icons.person_rounded,
                    outlineIcon: Icons.person_outline_rounded,
                  ),
                  _navItem(
                    index: 4,
                    icon: Icons.shopping_bag_rounded,
                    outlineIcon: Icons.shopping_bag_outlined,
                    badgeCount: bagBadgeCount,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData outlineIcon,
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;

    Widget iconWidget = Icon(
      isSelected ? icon : outlineIcon,
      size: 24,
      color: isSelected ? AppColors.white : AppColors.black,
    );

    if (badgeCount > 0 && !isSelected) {
      iconWidget = Badge(
        label: Text('$badgeCount', style: const TextStyle(fontSize: 9, color: AppColors.white)),
        backgroundColor: AppColors.alertRed,
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 22, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.terracotta : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.terracotta.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: iconWidget,
      ),
    );
  }
}
