import 'package:flutter/material.dart';
import 'app_colors.dart';

class StateColorUtils {
  /// Returns a specific color for unit and property statuses
  static Color getStatusColor(String? status) {
    switch (status) {
      case 'available':
      case 'vacant':
        return AppColors.success;
      case 'rented':
      case 'leased':
      case 'owned':
        return Colors.blue;
      case 'maintenance':
        return AppColors.warning;
      case 'reserved':
        return Colors.amber;
      case 'for_rent':
        return Colors.cyan;
      case 'for_sale':
        return Colors.deepOrange;
      case 'contracting':
        return Colors.indigo;
      case 'sent':
        return Colors.blueGrey;
      case 'draft':
        return AppColors.textSecondaryLight;
      case 'published':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  /// Returns a specific color for unit types
  static Color getUnitTypeColor(String? type) {
    switch (type) {
      case 'apartment':
        return Colors.indigo;
      case 'furnished_apartment':
        return Colors.deepPurple;
      case 'office':
        return Colors.blueGrey;
      case 'shop':
        return Colors.pink;
      case 'villa':
        return Colors.purple;
      case 'warehouse':
      case 'store':
        return Colors.brown;
      case 'parking':
        return Colors.grey.shade700;
      default:
        return AppColors.primary;
    }
  }

  /// Returns a specific color for unit purposes
  static Color getPurposeColor(String? purpose) {
    switch (purpose) {
      case 'for_rent':
        return Colors.cyan;
      case 'for_sale':
        return Colors.deepOrange;
      case 'contracting':
        return Colors.indigo;
      default:
        return AppColors.primary;
    }
  }

  /// Returns a specific color for usage types
  static Color getUsageTypeColor(String? usageType) {
    switch (usageType) {
      case 'residential':
        return Colors.blue;
      case 'commercial':
        return Colors.orange;
      case 'industrial':
        return Colors.brown;
      case 'mixed':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }
}
