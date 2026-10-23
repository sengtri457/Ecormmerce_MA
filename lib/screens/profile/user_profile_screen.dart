import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const UserProfileScreen({super.key, this.onBack});

  ImageProvider? _getAvatarProvider(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final clean = url.trim();
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return NetworkImage(clean);
    }
    final assetPath = clean.startsWith('/') ? clean.substring(1) : clean;
    return AssetImage(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.maybePop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.black,
              size: 18,
            ),
            tooltip: 'Back',
            onPressed: () {
              if (onBack != null) {
                onBack!();
              } else {
                Navigator.maybePop(context);
              }
            },
          ),
          title: Text(
            'ACCOUNT',
            style: AppTypography.headingSmall.copyWith(letterSpacing: 1.2),
          ),
        ),
        body: ListenableBuilder(
          listenable: mockService,
          builder: (context, _) {
            // Simple Logic: If not logged in, show simple prompt
            if (!mockService.isLoggedIn) {
              return _buildSimpleLoginPrompt(context);
            }

            final profile = mockService.userProfile;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 46,
                                backgroundColor: AppColors.surfaceSubtle,
                                backgroundImage: (profile != null &&
                                        profile.avatarUrl.isNotEmpty)
                                    ? _getAvatarProvider(profile.avatarUrl)
                                    : null,
                                onBackgroundImageError: (profile != null &&
                                        profile.avatarUrl.isNotEmpty)
                                    ? (_, _) {}
                                    : null,
                                child: (profile == null ||
                                        profile.avatarUrl.isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        size: 46,
                                        color: AppColors.textSecondary,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile?.fullName.toUpperCase() ?? 'SENGTRI DOE',
                          style: AppTypography.headingLarge.copyWith(
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile?.email ?? 'sengtri@example.com',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            profile?.tier ?? 'VIP MEMBER',
                            style: AppTypography.badge.copyWith(
                              letterSpacing: 1.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statItem(
                              'ORDERS',
                              '${profile?.ordersCount ?? 0}',
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: AppColors.border,
                            ),
                            _statItem(
                              'WISHLIST',
                              '${profile?.wishlistCount ?? 0}',
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              color: AppColors.border,
                            ),
                            _statItem(
                              'ADDRESSES',
                              '${profile?.addresses.length ?? 0}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionHeader('ORDERS & PURCHASES'),
                  _menuItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Order History',
                    subtitle: 'Track, return, or buy again',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Invoices & Receipts',
                    subtitle: 'Download invoices for tax purposes',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _sectionHeader('ACCOUNT SETTINGS'),
                  _menuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Name, email, phone number',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle:
                        '${profile?.addresses.length ?? 0} saved locations',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Cards, digital wallets',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    subtitle: 'Sales, drops, order updates',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _sectionHeader('SERVICES & SUPPORT'),
                  _menuItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Customer Concierge',
                    subtitle: '24/7 priority support',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Terms of service, privacy policy',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.white,
                            title: Text(
                              'LOG OUT',
                              style: AppTypography.headingSmall,
                            ),
                            content: Text(
                              'Are you sure you want to log out?',
                              style: AppTypography.bodySmall,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'CANCEL',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.alertRed,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  mockService.logout();
                                },
                                child: Text(
                                  'LOG OUT',
                                  style: AppTypography.badge.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(
                          color: AppColors.alertRed,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'LOG OUT',
                        style: AppTypography.button.copyWith(
                          color: AppColors.alertRed,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Simple Login Prompt Widget when user is a guest (not logged in)
  Widget _buildSimpleLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 40,
                color: AppColors.placeholder,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'SIGN IN REQUIRED',
              style: AppTypography.headingMedium.copyWith(
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please sign in or create an account to view your profile, orders, and saved addresses.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInScreen(returnOnSuccess: true),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                'SIGN IN',
                style: AppTypography.button.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.badge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: AppTypography.formLabel.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.black),
      ),
      title: Text(
        title,
        style: AppTypography.headingSmall.copyWith(fontSize: 14),
      ),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 20,
      color: AppColors.border,
    );
  }
}
