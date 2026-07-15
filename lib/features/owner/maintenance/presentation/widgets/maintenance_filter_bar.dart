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
              _buildChip(context, LocaleKeys.maintenanceFilterAll.tr(), 'all',
                  active),
              _buildChip(context, LocaleKeys.maintenanceFilterPending.tr(),
                  'pending', active),
              _buildChip(context, LocaleKeys.maintenanceFilterInProgress.tr(),
                  'in_progress', active),
              _buildChip(context, LocaleKeys.maintenanceFilterCompleted.tr(),
                  'executed', active),
              _buildChip(context, LocaleKeys.maintenanceFilterCancelled.tr(),
                  'cancelled', active),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
      BuildContext context, String label, String status, String active) {
    final isSelected = status == active;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => context
            .read<OwnerMaintenanceCubit>()
            .changeStatusFilter(status),
        backgroundColor: AppColors.surfaceLight,
        selectedColor: context.primaryColor,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularFull,
          side: BorderSide(
              color: isSelected ? context.primaryColor : AppColors.borderLight),
        ),
      ),
    );
  }
}
