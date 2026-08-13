import 'package:flutter/widgets.dart';

enum AppWindowSize { compact, medium, expanded }

class AppBreakpoints {
  AppBreakpoints._();

  static const double compact = 600;
  static const double expanded = 1024;
  static const double contentMaxWidth = 1440;

  static AppWindowSize windowSizeFor(double width) {
    if (width < compact) return AppWindowSize.compact;
    if (width < expanded) return AppWindowSize.medium;
    return AppWindowSize.expanded;
  }

  static double horizontalPaddingFor(double width) {
    return switch (windowSizeFor(width)) {
      AppWindowSize.compact => 16,
      AppWindowSize.medium => 24,
      AppWindowSize.expanded => 32,
    };
  }
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  AppWindowSize get windowSize => AppBreakpoints.windowSizeFor(screenWidth);
  bool get isCompact => windowSize == AppWindowSize.compact;
  bool get isMedium => windowSize == AppWindowSize.medium;
  bool get isExpanded => windowSize == AppWindowSize.expanded;
  double get pagePadding => AppBreakpoints.horizontalPaddingFor(screenWidth);
}
