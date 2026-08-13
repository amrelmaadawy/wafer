import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';

({Color color, IconData icon, String label}) installmentStatusStyle(
  String status,
) {
  return switch (status.toLowerCase()) {
    'paid' => (
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
      label: LocaleKeys.installmentsStatusPaid.tr(),
    ),
    'overdue' => (
      color: AppColors.error,
      icon: Icons.error_rounded,
      label: LocaleKeys.installmentsStatusOverdue.tr(),
    ),
    'partially_paid' => (
      color: AppColors.info,
      icon: Icons.timelapse_rounded,
      label: LocaleKeys.installmentsStatusPartial.tr(),
    ),
    _ => (
      color: AppColors.warning,
      icon: Icons.schedule_rounded,
      label: LocaleKeys.installmentsStatusUnpaid.tr(),
    ),
  };
}
