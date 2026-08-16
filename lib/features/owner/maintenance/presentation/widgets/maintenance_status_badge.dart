import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/maintenance_status.dart';
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
      case MaintenanceStatus.new_:
      case 'pending':
        bg = AppColors.warning.withValues(alpha: 0.12);
        fg = AppColors.warning;
        labelKey = LocaleKeys.maintenanceStatusPending;
        break;
      case MaintenanceStatus.pendingSupervisor:
        bg = const Color(0xFFD97706).withValues(alpha: 0.12); // Amber
        fg = const Color(0xFFD97706);
        labelKey = LocaleKeys.maintenanceStatusPendingSupervisor;
        break;
      case MaintenanceStatus.approved:
        bg = AppColors.info.withValues(alpha: 0.12); // Blue
        fg = AppColors.info;
        labelKey = LocaleKeys.maintenanceStatusApproved;
        break;
      case MaintenanceStatus.assigned:
        bg = const Color(0xFF6366F1).withValues(alpha: 0.12); // Indigo
        fg = const Color(0xFF6366F1);
        labelKey = LocaleKeys.maintenanceStatusAssigned;
        break;
      case MaintenanceStatus.inProgress:
        bg = const Color(0xFF8B5CF6).withValues(alpha: 0.12); // Purple
        fg = const Color(0xFF8B5CF6);
        labelKey = LocaleKeys.maintenanceStatusInProgress;
        break;
      case MaintenanceStatus.executed:
      case 'completed':
        bg = AppColors.success.withValues(alpha: 0.12); // Green
        fg = AppColors.success;
        labelKey = LocaleKeys.maintenanceStatusExecuted;
        break;
      case 'pending_closure':
        bg = const Color(0xFF14B8A6).withValues(alpha: 0.12); // Teal
        fg = const Color(0xFF14B8A6);
        labelKey = LocaleKeys.maintenanceStatusPendingClosure;
        break;
      case MaintenanceStatus.closed:
        bg = const Color(0xFF64748B).withValues(alpha: 0.12); // Slate
        fg = const Color(0xFF64748B);
        labelKey = LocaleKeys.maintenanceStatusClosed;
        break;
      case 'forwarded':
        bg = const Color(0xFF06B6D4).withValues(alpha: 0.12); // Cyan
        fg = const Color(0xFF06B6D4);
        labelKey = LocaleKeys.maintenanceStatusForwarded;
        break;
      case MaintenanceStatus.rejected:
        bg = AppColors.error.withValues(alpha: 0.12); // Red
        fg = AppColors.error;
        labelKey = LocaleKeys.maintenanceStatusRejected;
        break;
      case MaintenanceStatus.cancelled:
        bg = const Color(0xFFF97316).withValues(alpha: 0.12); // Orange-Red
        fg = const Color(0xFFF97316);
        labelKey = LocaleKeys.maintenanceStatusCancelled;
        break;
      default:
        bg = AppColors.borderLight;
        fg = AppColors.textPrimaryLight;
        labelKey = LocaleKeys.maintenanceStatusPending;
    }

    final displayLabel = statusLabel.isNotEmpty ? statusLabel : labelKey.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.circularMd),
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
