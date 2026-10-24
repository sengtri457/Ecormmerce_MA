import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';

class CategoryDepartmentSwitcher extends StatelessWidget {
  final List<String> departments;
  final String selectedDepartment;
  final ValueChanged<String> onDepartmentSelected;

  const CategoryDepartmentSwitcher({
    super.key,
    required this.departments,
    required this.selectedDepartment,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: Row(
        children: departments.map((dept) {
          final isSelected = selectedDepartment == dept.toLowerCase();
          return Expanded(
            child: InkWell(
              onTap: () => onDepartmentSelected(dept.toLowerCase()),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      width: 2.2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    dept,
                    style: AppTypography.headingSmall.copyWith(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      letterSpacing: 2.0,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
