import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';

class MaintenancePriorityBadge extends StatelessWidget {
  final String priority;
  final String? label;

  const MaintenancePriorityBadge({
    super.key,
    required this.priority,
    this.label,
  });

  Color _getPriorityColor() {
    switch (priority.toLowerCase().trim()) {
      case 'urgent':
        return AppColors.error;
      case 'high':
        return const Color(0xFFD97706);
      case 'medium':
        return AppColors.warning;
      case 'low':
      default:
        return AppColors.info;
    }
  }

  String _getPriorityLabel() {
    if (label != null && label!.trim().isNotEmpty) {
      return label!;
    }
    switch (priority.toLowerCase().trim()) {
      case 'urgent':
        return LocaleKeys.maintenancePriorityUrgent.tr();
      case 'high':
        return LocaleKeys.maintenancePriorityHigh.tr();
      case 'medium':
        return LocaleKeys.maintenancePriorityMedium.tr();
      case 'low':
      default:
        return LocaleKeys.maintenancePriorityLow.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor();
    final text = _getPriorityLabel();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
