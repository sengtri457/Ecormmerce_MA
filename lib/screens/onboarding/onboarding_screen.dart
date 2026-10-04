import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/app_button.dart';
import '../auth/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final items = mockService.onboardingItems;

    if (items.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.black)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background PageView with Images
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surfaceSubtle),
                  ),
                  // Dark Vignette Gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Bar with Skip Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logoDevs.png',
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      'MA STUDIO',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                    child: Text(
                      'SKIP',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Content & Navigation
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step Indicator Dots
                Row(
                  children: List.generate(items.length, (index) {
                    final isActive = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 4,
                      width: isActive ? 32 : 12,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.white : AppColors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  items[_currentIndex].title,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  items[_currentIndex].subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 32),

                // CTA Button
                AppButton(
                  text: _currentIndex == items.length - 1 ? 'GET STARTED' : 'CONTINUE',
                  variant: AppButtonVariant.primary,
                  onPressed: () {
                    if (_currentIndex < items.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
