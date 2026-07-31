import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class MaintenanceHeader extends StatelessWidget {
  const MaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (Navigator.canPop(context)) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.circularLg,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.primaryColor,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                LocaleKeys.maintenanceTitle.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularLg,
            ),
            child: IconButton(
              icon: Icon(
                Icons.gavel_rounded,
                color: context.primaryColor,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              tooltip: LocaleKeys.negotiation_list_title.tr(),
              onPressed: () => context.push(Routes.ownerNegotiationsList),
            ),
          ),
        ],
      ),
    );
  }
}
