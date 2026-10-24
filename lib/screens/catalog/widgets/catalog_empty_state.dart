import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 48,
            color: AppColors.placeholder,
          ),
          const SizedBox(height: 12),
          Text(
            'NO PRODUCTS MATCH YOUR FILTER',
            style: AppTypography.headingSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Try resetting filters or adjusting search term.',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
