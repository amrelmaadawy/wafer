import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

(IconData, Color) activityLogActionStyle(String action) =>
    switch (action.toLowerCase()) {
      'create' ||
      'created' => (Icons.add_circle_outline_rounded, AppColors.success),
      'update' || 'updated' => (Icons.edit_outlined, AppColors.warning),
      'delete' || 'deleted' => (Icons.delete_outline_rounded, AppColors.error),
      _ => (Icons.info_outline_rounded, Colors.blue),
    };
