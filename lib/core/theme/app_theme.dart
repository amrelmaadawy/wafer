import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  /// Default primary color used on first launch before user customization.
  static const Color defaultPrimary = Color(0xFF1E3A8A);

  /// Builds a light [ThemeData] using the given [primary] color.
  /// All color-sensitive components (ColorScheme, ElevatedButton, etc.)
  /// are derived from [primary] so the entire UI reacts to theme changes.
  static ThemeData buildLight(Color primary) {
    final colorScheme = ColorScheme.light(
      primary: primary,
      primaryContainer: primary.withValues(alpha: 0.12),
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppFonts.fontFamilyPrimary,
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(
        AppColors.textPrimaryLight,
        AppColors.textSecondaryLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : null,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondaryLight.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  /// Builds a dark [ThemeData] using the given [primary] color.
  static ThemeData buildDark(Color primary) {
    final colorScheme = ColorScheme.dark(
      primary: primary,
      primaryContainer: primary.withValues(alpha: 0.18),
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppFonts.fontFamilyPrimary,
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(
        AppColors.textPrimaryDark,
        AppColors.textSecondaryDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: primary),
      displayMedium: AppTextStyles.h2.copyWith(color: primary),
      displaySmall: AppTextStyles.h3.copyWith(color: primary),
      headlineLarge: AppTextStyles.h1.copyWith(color: primary),
      headlineMedium: AppTextStyles.h2.copyWith(color: primary),
      headlineSmall: AppTextStyles.h3.copyWith(color: primary),
      titleLarge: AppTextStyles.h3.copyWith(color: primary),
      titleMedium: AppTextStyles.h4.copyWith(color: primary),
      titleSmall: AppTextStyles.labelLarge.copyWith(color: primary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: secondary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: secondary),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: primary),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: secondary),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: secondary),
    );
  }
}
