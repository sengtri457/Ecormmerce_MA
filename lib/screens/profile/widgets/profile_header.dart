import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile? profile;

  const ProfileHeader({super.key, required this.profile});

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
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.surfaceSubtle,
                  backgroundImage:
                      (profile != null && profile!.avatarUrl.isNotEmpty)
                          ? _getAvatarProvider(profile!.avatarUrl)
                          : null,
                  onBackgroundImageError:
                      (profile != null && profile!.avatarUrl.isNotEmpty)
                          ? (_, _) {}
                          : null,
                  child: (profile == null || profile!.avatarUrl.isEmpty)
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
                      border: Border.all(color: AppColors.white, width: 2),
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
            style: AppTypography.headingLarge.copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? 'sengtri@example.com',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              _statItem('ORDERS', '${profile?.ordersCount ?? 0}'),
              Container(height: 30, width: 1, color: AppColors.border),
              _statItem('WISHLIST', '${profile?.wishlistCount ?? 0}'),
              Container(height: 30, width: 1, color: AppColors.border),
              _statItem('ADDRESSES', '${profile?.addresses.length ?? 0}'),
            ],
          ),
        ],
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
}
