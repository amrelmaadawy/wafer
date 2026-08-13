import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/theme_context.dart';

class AppSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: context.appSurfaceColor,
      borderRadius: AppRadius.circularXl,
      border: Border.all(color: context.appBorderColor),
      boxShadow: Theme.of(context).brightness == Brightness.dark
          ? AppShadows.cardDark
          : AppShadows.cardLight,
    );
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.circularXl,
          child: content,
        ),
      ),
    );
  }
}
