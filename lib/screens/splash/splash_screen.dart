import 'dart:async';
import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../main_nav_screen.dart';

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
  late final Animation<double> _progressAnimation;

  bool _isDataReady = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 1.0, curve: Curves.easeInOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _proceed();
      }
    });

    _controller.forward();
    _initServices();
  }

  Future<void> _initServices() async {
    try {
      await Future.wait([
        MockDataService().initialize(),
        MockDataService().loadCategoryProducts(),
      ]);
    } catch (_) {}

    if (mounted) {
      _isDataReady = true;
    }
  }

  void _proceed() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_isDataReady) {
              _proceed();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Image.asset(
                              'assets/images/logoDevs.png',
                              height: 58,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                    'MA',
                                    style: AppTypography.displayLarge.copyWith(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 4.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'MA STUDIO',
                            style: AppTypography.headingSmall.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 5.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'CURATED FASHION & LIFESTYLE',
                            style: AppTypography.badge.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 160,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Container(
                                    height: 3,
                                    width: 160,
                                    color: AppColors.surfaceSubtle,
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: _progressAnimation.value
                                          .clamp(0.0, 1.0),
                                      child: Container(
                                        height: 3,
                                        color: AppColors.terracotta,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'LOADING COLLECTION',
                                  style: AppTypography.badge.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 1.6,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
