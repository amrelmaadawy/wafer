import 'package:flutter/material.dart';

/// Extension on [Color] to derive darker/lighter shades from any base color.
/// Used to build dynamic gradients that respond to the user's chosen primary color.
extension ColorUtils on Color {
  /// Returns a darker shade by reducing HSL lightness by [factor] (0.0–1.0).
  Color darken([double factor = 0.2]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - factor).clamp(0.0, 1.0)).toColor();
  }

  /// Returns a lighter shade by increasing HSL lightness by [factor] (0.0–1.0).
  Color lighten([double factor = 0.15]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0)).toColor();
  }

  /// Returns the color with reduced saturation (more muted/neutral look).
  Color muted([double factor = 0.3]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation - factor).clamp(0.0, 1.0)).toColor();
  }

  /// Returns the color with [alpha] opacity (0.0–1.0).
  Color withA(double alpha) => withValues(alpha: alpha);
}

/// Extension on [BuildContext] for quick access to primary color and its shades.
///
/// Always reads from [Theme.of(context).colorScheme.primary] to ensure
/// dynamic color changes propagate correctly across the entire app.
///
/// Usage:
/// ```dart
/// color: context.primaryColor           // base primary
/// color: context.primaryDark            // for gradient start
/// color: context.primaryLight           // for gradient end / highlights
/// colors: [context.primaryDark, context.primaryColor, context.primaryLight]
/// ```
extension BuildContextColors on BuildContext {
  /// The current primary color from [ThemeData.colorScheme].
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// A noticeably darker shade — used as gradient start or deep shadows.
  Color get primaryDark => primaryColor.darken(0.22);

  /// A slightly darker shade — used as gradient middle step.
  Color get primaryMid => primaryColor.darken(0.08);

  /// A lighter shade — used for hover states, highlights, or gradient end.
  Color get primaryLight => primaryColor.lighten(0.14);

  /// 8% opacity version — for subtle background tints.
  Color get primaryFaint => primaryColor.withA(0.08);

  /// 15% opacity version — for icon container backgrounds.
  Color get primarySubtle => primaryColor.withA(0.15);

  /// 35% opacity version — for colored box shadows.
  Color get primaryShadow => primaryColor.withA(0.35);
}
