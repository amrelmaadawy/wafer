import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeContext on BuildContext {
  Color get appBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get appSurfaceColor => Theme.of(this).colorScheme.surface;
  Color get appOnSurfaceColor => Theme.of(this).colorScheme.onSurface;

  Color get appSecondaryTextColor =>
      Theme.of(this).textTheme.bodyMedium?.color ?? appOnSurfaceColor;

  Color get appBorderColor => Theme.of(this).brightness == Brightness.dark
      ? AppColors.borderDark
      : AppColors.borderLight;

  Color get appSubtleSurfaceColor =>
      Theme.of(this).brightness == Brightness.dark
      ? AppColors.surfaceSubtleDark
      : AppColors.surfaceSubtleLight;
}
