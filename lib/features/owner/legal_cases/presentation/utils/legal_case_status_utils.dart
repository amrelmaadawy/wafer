import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';

class LegalCaseStatusUtils {
  static Color getStatusColor(String? colorCode, BuildContext context) {
    if (colorCode == null) return AppColors.primaryDark;
    switch (colorCode) {
      case 'primary':
        return context.primaryColor;
      case 'success':
        return AppColors.success;
      case 'danger':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      case 'info':
        return AppColors.info;
      case 'dark':
        return AppColors.primaryDark;
      case 'light':
        return AppColors.surfaceLight;
      default:
        return AppColors.primaryDark;
    }
  }
}
