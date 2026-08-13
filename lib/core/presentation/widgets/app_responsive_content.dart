import 'package:flutter/material.dart';
import '../../theme/app_breakpoints.dart';

class AppResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;
  final AlignmentGeometry alignment;

  const AppResponsiveContent({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = AppBreakpoints.contentMaxWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: context.pagePadding),
          child: child,
        ),
      ),
    );
  }
}
