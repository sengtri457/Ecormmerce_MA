import 'package:flutter/material.dart';
import '../../../helpers/app_colors.dart';
import '../../../helpers/app_typography.dart';
import '../../../services/department_repository.dart';

class DepartmentTabBar extends StatelessWidget {
  final String selectedDepartmentId;
  final ValueChanged<String> onDepartmentSelected;

  const DepartmentTabBar({
    super.key,
    required this.selectedDepartmentId,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: Row(
        children: DepartmentRepository.departments.map((dept) {
          final isSelected = selectedDepartmentId == dept['id'];
          return Expanded(
            child: InkWell(
              onTap: () => onDepartmentSelected(dept['id']!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.black : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  dept['name']!,
                  style: AppTypography.badge.copyWith(
                    fontSize: 12,
                    letterSpacing: 1.0,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.black
                        : AppColors.textSecondary,
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
