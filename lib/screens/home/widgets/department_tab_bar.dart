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
          final isSelected = selectedDepartmentId == dept.id;
          return Expanded(
            child: InkWell(
              onTap: () => onDepartmentSelected(dept.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dept.name,
                      style: AppTypography.badge.copyWith(
                        fontSize: 12,
                        letterSpacing: 1.1,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.black
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      height: 2.0,
                      width: isSelected ? 28.0 : 0.0,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
