import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class MaintenanceStatusBadge extends StatelessWidget {
  final String status;
  final String statusLabel;

  const MaintenanceStatusBadge({
    super.key,
    required this.status,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase().trim();

    Color bg;
    Color fg;
    String labelKey = '';

    switch (lower) {
      case 'pending':
      case 'new':
        bg = AppColors.warning.withValues(alpha: 0.12);
        fg = AppColors.warning;
        labelKey = LocaleKeys.maintenanceStatusPending;
        break;
      case 'approved':
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        labelKey = LocaleKeys.maintenanceStatusApproved;
        break;
      case 'in_progress':
      case 'assigned':
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.12);
        fg = const Color(0xFF8B5CF6);
        labelKey = LocaleKeys.maintenanceStatusInProgress;
        break;
      case 'executed':
      case 'completed':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        labelKey = LocaleKeys.maintenanceStatusExecuted;
        break;
      case 'rejected':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        labelKey = LocaleKeys.maintenanceStatusRejected;
        break;
      case 'cancelled':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        labelKey = LocaleKeys.maintenanceStatusCancelled;
        break;
      default:
        bg = AppColors.borderLight;
        fg = AppColors.textPrimaryLight;
        labelKey = LocaleKeys.maintenanceStatusPending;
    }

    final displayLabel =
        statusLabel.isNotEmpty ? statusLabel : labelKey.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circularMd,
      ),
      child: Text(
        displayLabel,
        style: TextStyle(
          color: fg,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
