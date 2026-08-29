import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';

enum AppStatusBadgeSize { small, medium }

/// Displays a colored status badge with text and optional icon.
/// Used in list items and detail screens for status representation.
class AppStatusBadge extends StatelessWidget {
  final String labelKey;
  final Color color;
  final IconData? icon;
  final AppStatusBadgeSize size;
  final bool translateText;

  const AppStatusBadge({
    super.key,
    required this.labelKey,
    required this.color,
    this.icon,
    this.size = AppStatusBadgeSize.small,
    this.translateText = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = size == AppStatusBadgeSize.small;
    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final fontSize = isSmall ? 10.0 : 12.0;
    final iconSize = isSmall ? 12.0 : 14.0;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            translateText ? labelKey.tr() : labelKey,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
