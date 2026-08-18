import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
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
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
              child: Material(
                color: context.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.menu_rounded,
                      color: context.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
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
