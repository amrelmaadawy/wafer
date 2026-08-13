import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';

class ContractSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const ContractSectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.primaryColor, size: 20),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.appOnSurfaceColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
