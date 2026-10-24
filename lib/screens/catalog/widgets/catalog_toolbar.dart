import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';

class CatalogToolbar extends StatelessWidget {
  final int itemCount;
  final bool isGridView;
  final VoidCallback onToggleView;
  final VoidCallback onOpenFilter;

  const CatalogToolbar({
    super.key,
    required this.itemCount,
    required this.isGridView,
    required this.onToggleView,
    required this.onOpenFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$itemCount ITEMS',
            style: AppTypography.formLabel.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isGridView ? Icons.view_agenda_outlined : Icons.grid_view,
                  size: 20,
                  color: AppColors.black,
                ),
                onPressed: onToggleView,
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: onOpenFilter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 16, color: AppColors.black),
                      const SizedBox(width: 6),
                      Text(
                        'FILTER',
                        style: AppTypography.badge.copyWith(letterSpacing: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
