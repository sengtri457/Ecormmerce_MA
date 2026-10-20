import 'dart:async';
import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    final startTime = DateTime.now();

    try {
      await Future.wait([
        MockDataService().initialize(),
        MockDataService().loadCategoryProducts(),
      ]);
    } catch (_) {}

    final elapsed = DateTime.now().difference(startTime);
    final remainingDelay = const Duration(milliseconds: 1800) - elapsed;
    if (remainingDelay > Duration.zero) {
      final completer = Completer<void>();
      _timer = Timer(remainingDelay, () {
        if (!completer.isCompleted) completer.complete();
      });
      await completer.future;
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Centered Brandmark & Identity
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo
                    Image.asset(
                      'assets/images/logoDevs.png',
                      height: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'MA',
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Typographic Wordmark & Tagline
                    Text(
                      'MA STUDIO',
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CURATED FASHION & LIFESTYLE',
                      style: AppTypography.badge.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Subtle Accent Indicator (Warm Terracotta)
                    Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.terracotta,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Editorial Edition Mark
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'EST. 2026 • NEW YORK • PARIS',
                  style: AppTypography.badge.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
