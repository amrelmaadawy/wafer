import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';

class LegalCasesFilterChips extends StatelessWidget {
  final Map<String, int> statsByStatus;
  final String? selectedStatus;
  final Function(String?) onStatusSelected;

  const LegalCasesFilterChips({
    super.key,
    required this.statsByStatus,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (statsByStatus.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildChip(
            context: context,
            label: 'الكل',
            count: statsByStatus.values.fold(0, (sum, val) => sum + val),
            isSelected: selectedStatus == null || selectedStatus == 'الكل',
            onTap: () => onStatusSelected(null),
          ),
          ...statsByStatus.entries.map((entry) {
            return _buildChip(
              context: context,
              label: entry.key,
              count: entry.value,
              isSelected: selectedStatus == entry.key,
              onTap: () => onStatusSelected(entry.key),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXxl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : Colors.white,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(
              color: isSelected ? context.primaryColor : AppColors.borderLight,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                  fontWeight: isSelected ? AppFonts.semiBold : AppFonts.medium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.backgroundLight,
                  borderRadius: AppRadius.circularLg,
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                    fontSize: 11,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
