import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import 'contracts_filter_bar.dart';

class ContractsPageHeader extends StatelessWidget {
  final int? totalCount;

  const ContractsPageHeader({super.key, this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.contractsTitle.tr(),
                style: AppTextStyles.h3.copyWith(
                  color: context.appOnSurfaceColor,
                ),
              ),
            ),
            if (totalCount != null)
              Text(
                '${LocaleKeys.contractsTotalCount.tr()}: $totalCount',
                style: AppTextStyles.labelMedium.copyWith(
                  color: context.appSecondaryTextColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const ContractsFilterBar(),
      ],
    );
  }
}
