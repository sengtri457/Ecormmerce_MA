import 'package:flutter/material.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/app_typography.dart';
import '../../widgets/app_button.dart';

class SizeGuideSheet extends StatelessWidget {
  const SizeGuideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SIZE & FIT GUIDE',
                  style: AppTypography.headingMedium.copyWith(letterSpacing: 1.0),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Measurements are in inches. Garments are tailored with modern relaxed proportions.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 20),

            // Mannequin Measurement Visual Box (Matching Figma size-guide node)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.accessibility_new, size: 40, color: AppColors.textSecondary),
                        Text('CHEST', style: AppTypography.badge.copyWith(fontSize: 8, color: AppColors.terracotta)),
                        Text('WAIST', style: AppTypography.badge.copyWith(fontSize: 8, color: AppColors.terracotta)),
                        Text('HIPS', style: AppTypography.badge.copyWith(fontSize: 8, color: AppColors.terracotta)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _measurePoint('1. Chest / Bust', 'Measure around the fullest part of your chest.'),
                        const SizedBox(height: 8),
                        _measurePoint('2. Natural Waist', 'Measure around the narrowest part of your torso.'),
                        const SizedBox(height: 8),
                        _measurePoint('3. Hips', 'Measure around the fullest point of your hips.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sizing Table
            Table(
              border: TableBorder.all(color: AppColors.border, width: 1),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: AppColors.surfaceLight),
                  children: [
                    _headerCell('SIZE'),
                    _headerCell('CHEST'),
                    _headerCell('WAIST'),
                    _headerCell('HIPS'),
                  ],
                ),
                _dataRow('S (36)', '36 - 38"', '28 - 30"', '36 - 38"'),
                _dataRow('M (38)', '39 - 41"', '31 - 33"', '39 - 41"'),
                _dataRow('L (40)', '42 - 44"', '34 - 36"', '42 - 44"'),
                _dataRow('XL (42)', '45 - 47"', '37 - 39"', '45 - 47"'),
                _dataRow('XXL (44)', '48 - 50"', '40 - 42"', '48 - 50"'),
              ],
            ),
            const SizedBox(height: 28),
            AppButton(
              text: 'GOT IT',
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _measurePoint(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.badge.copyWith(fontWeight: FontWeight.w700, color: AppColors.black)),
        Text(desc, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.badge.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  TableRow _dataRow(String size, String chest, String waist, String hips) {
    return TableRow(
      children: [
        _cell(size, isBold: true),
        _cell(chest),
        _cell(waist),
        _cell(hips),
      ],
    );
  }

  Widget _cell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
