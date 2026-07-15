import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_maintenance_cubit.dart';
import '../cubit/owner_maintenance_state.dart';

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
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: AppRadius.circularMd,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: AppRadius.circularMd,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimaryLight,
                    ),
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
          BlocBuilder<OwnerMaintenanceCubit, OwnerMaintenanceState>(
            builder: (context, state) {
              int total = 0;
              if (state is OwnerMaintenanceLoaded) total = state.meta.total;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '${LocaleKeys.maintenanceTotalCount.tr()}: $total',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
