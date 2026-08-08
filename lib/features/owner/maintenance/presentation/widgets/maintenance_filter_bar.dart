import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_maintenance_cubit.dart';
import '../cubit/owner_maintenance_state.dart';

class MaintenanceFilterBar extends StatelessWidget {
  const MaintenanceFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerMaintenanceCubit, OwnerMaintenanceState>(
      builder: (context, state) {
        String active = context.read<OwnerMaintenanceCubit>().currentStatus;
        if (state is OwnerMaintenanceLoaded) {
          active = state.activeStatus;
        } else if (state is OwnerMaintenanceEmpty) {
          active = state.activeStatus;
        } else if (state is OwnerMaintenanceLoading) {
          active = state.activeStatus;
        } else if (state is OwnerMaintenanceError) {
          active = state.activeStatus;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              _buildChip(
                context,
                LocaleKeys.maintenanceFilterAll.tr(),
                'all',
                active,
              ),
              _buildChip(
                context,
                LocaleKeys.maintenanceFilterPending.tr(),
                'pending',
                active,
              ),
              _buildChip(
                context,
                LocaleKeys.maintenanceFilterInProgress.tr(),
                'in_progress',
                active,
              ),
              _buildChip(
                context,
                LocaleKeys.maintenanceFilterCompleted.tr(),
                'executed',
                active,
              ),
              _buildChip(
                context,
                LocaleKeys.maintenanceFilterCancelled.tr(),
                'cancelled',
                active,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    String status,
    String active,
  ) {
    final isSelected = status == active;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : AppColors.surfaceLight,
          borderRadius: AppRadius.circularFull,
          border: Border.all(
            color: isSelected ? context.primaryColor : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primaryShadow.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.circularFull,
          child: InkWell(
            borderRadius: AppRadius.circularFull,
            onTap: () {
              // Only trigger if not already selected to avoid unnecessary rebuilds
              if (!isSelected) {
                context.read<OwnerMaintenanceCubit>().changeStatusFilter(status);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily, // Inherit font
                  color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                child: Text(label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
