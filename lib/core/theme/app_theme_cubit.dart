import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_theme.dart';

/// Manages the active [ThemeData] and persists the user's chosen primary color.
///
/// Integrates with [SharedPreferences] via [CacheHelper] to save/restore
/// the selected color across app restarts.
class AppThemeCubit extends Cubit<ThemeData> {
  static final int _defaultColorValue = AppTheme.defaultPrimary.toARGB32();
  static const String _colorKey = 'primary_color_value';

  final _prefs = <String, int>{};

  AppThemeCubit() : super(AppTheme.buildLight(AppTheme.defaultPrimary));

  /// Loads the saved primary color from storage and applies it.
  /// Call this once at app startup inside [main.dart].
  void loadFromPrefs(int? savedColorValue) {
    final colorValue = savedColorValue ?? _defaultColorValue;
    _prefs[_colorKey] = colorValue;
    emit(AppTheme.buildLight(Color(colorValue)));
  }

  /// Changes the primary color, rebuilds the theme, and persists the value.
  /// Returns the int value to be saved externally via [CacheHelper].
  int changePrimaryColor(Color color) {
    _prefs[_colorKey] = color.toARGB32();
    emit(AppTheme.buildLight(color));
    return color.toARGB32();
  }

  /// The currently active primary color.
  Color get currentPrimary => state.colorScheme.primary;

  /// The ARGB int value of the current primary (for persistence).
  int get currentColorValue => currentPrimary.toARGB32();
}
