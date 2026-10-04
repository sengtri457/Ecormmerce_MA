import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../services/mock_data_service.dart';
import '../onboarding/onboarding_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockService = MockDataService();
    final profile = mockService.userProfile;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ACCOUNT',
          style: AppTypography.headingSmall.copyWith(letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Card Header
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  // Avatar with Camera Badge
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.surfaceSubtle,
                          backgroundImage: profile != null ? NetworkImage(profile.avatarUrl) : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Name & Email
                  Text(
                    profile?.fullName ?? 'Sengtri Chan',
                    style: AppTypography.headingMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? 'sengtri@example.com',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 12),

                  // VIP Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      profile?.tier.toUpperCase() ?? 'VIP MEMBER',
                      style: AppTypography.badge.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Quick Stats Row
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _statItem('ORDERS', '${profile?.ordersCount ?? 8}'),
                  Container(height: 30, width: 1, color: AppColors.border),
                  _statItem('WISHLIST', '${profile?.wishlistCount ?? 12}'),
                  Container(height: 30, width: 1, color: AppColors.border),
                  _statItem('ADDRESSES', '${profile?.addresses.length ?? 2}'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Settings & Options List
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _menuItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'My Orders',
                    subtitle: 'Track, exchange or view history',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    subtitle: '${profile?.addresses.length ?? 2} saved locations',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Cards',
                    subtitle: 'Mastercard •••• 8842',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifications & Alerts',
                    subtitle: 'Sale drops and order status',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Concierge & Help',
                    subtitle: '24/7 dedicated client services',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: AppColors.alertRed, width: 1.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Text(
                  'LOG OUT',
                  style: AppTypography.button.copyWith(color: AppColors.alertRed),
                ),
              ),
            ),
            const SizedBox(height: 110),
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
            style: AppTypography.headingMedium.copyWith(fontWeight: FontWeight.w700),
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

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.black, size: 22),
      title: Text(title, style: AppTypography.headingSmall.copyWith(fontSize: 14)),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 56, endIndent: 20, color: AppColors.border);
  }
}
