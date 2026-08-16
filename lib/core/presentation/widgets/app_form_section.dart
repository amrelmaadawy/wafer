import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A standardized form section wrapper with title and divider.
/// Replaces the ad-hoc _buildSectionTitle() methods in Feature screens.
class AppFormSection extends StatelessWidget {
  final String titleKey;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const AppFormSection({
    super.key,
    required this.titleKey,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titleKey.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.surfaceSubtle, height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
