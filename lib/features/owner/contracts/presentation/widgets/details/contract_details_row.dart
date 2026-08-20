import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';

class ContractDetailsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final Widget? trailingIcon;
  final Color? valueColor;

  const ContractDetailsRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.trailingIcon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (trailingIcon != null) ...[
                      trailingIcon!,
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Flexible(
                      child: Text(
                        value.isEmpty ? '-' : value,
                        textAlign: TextAlign.end,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: valueColor ?? context.appOnSurfaceColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: context.appBorderColor, height: 1),
      ],
    );
  }
}
