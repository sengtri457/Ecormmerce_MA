import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_login_prompt.dart';
import 'widgets/profile_menu_item.dart';

class UserProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const UserProfileScreen({super.key, this.onBack});

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  void _showLogoutDialog(BuildContext context, MockDataService mockService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('LOG OUT', style: AppTypography.headingSmall),
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
              style: AppTypography.badge.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack(context);
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
            onPressed: () => _handleBack(context),
          ),
          title: Text(
            'ACCOUNT',
            style: AppTypography.headingSmall.copyWith(letterSpacing: 1.2),
          ),
        ),
        body: ListenableBuilder(
          listenable: mockService,
          builder: (context, _) {
            if (!mockService.isLoggedIn) {
              return const ProfileLoginPrompt();
            }

            final profile = mockService.userProfile;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(profile: profile),
                  const SizedBox(height: 12),
                  _sectionHeader('ORDERS & PURCHASES'),
                  ProfileMenuItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Order History',
                    subtitle: 'Track, return, or buy again',
                    onTap: () {},
                  ),
                  _divider(),
                  ProfileMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Invoices & Receipts',
                    subtitle: 'Download invoices for tax purposes',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _sectionHeader('ACCOUNT SETTINGS'),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Name, email, phone number',
                    onTap: () {},
                  ),
                  _divider(),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: '${profile?.addresses.length ?? 0} saved locations',
                    onTap: () {},
                  ),
                  _divider(),
                  ProfileMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Cards, digital wallets',
                    onTap: () {},
                  ),
                  _divider(),
                  ProfileMenuItem(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications',
                    subtitle: 'Sales, drops, order updates',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _sectionHeader('SERVICES & SUPPORT'),
                  ProfileMenuItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Customer Concierge',
                    subtitle: '24/7 priority support',
                    onTap: () {},
                  ),
                  _divider(),
                  ProfileMenuItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Terms of service, privacy policy',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: () => _showLogoutDialog(context, mockService),
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

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 20,
      color: AppColors.border,
    );
  }
}
