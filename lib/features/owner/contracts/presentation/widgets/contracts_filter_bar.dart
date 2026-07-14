import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';

class ContractsFilterBar extends StatelessWidget {
  const ContractsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
      builder: (context, state) {
        String active = context.read<OwnerContractsCubit>().currentStatus;
        if (state is OwnerContractsLoaded) {
          active = state.activeStatus;
        } else if (state is OwnerContractsEmpty) {
          active = state.activeStatus;
        } else if (state is OwnerContractsLoading) {
          active = state.activeStatus;
        } else if (state is OwnerContractsError) {
          active = state.activeStatus;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              _buildChip(context, LocaleKeys.contractsFilterAll.tr(), 'all', active),
              _buildChip(context, LocaleKeys.contractsFilterActive.tr(), 'active', active),
              _buildChip(context, LocaleKeys.contractsFilterExpiring.tr(), 'expiring', active),
              _buildChip(context, LocaleKeys.contractsFilterDraft.tr(), 'draft', active),
              _buildChip(context, LocaleKeys.contractsFilterTerminated.tr(), 'terminated', active),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(BuildContext context, String label, String status, String active) {
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
        onSelected: (_) => context.read<OwnerContractsCubit>().changeStatusFilter(status),
        backgroundColor: AppColors.surfaceLight,
        selectedColor: context.primaryColor,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.circularFull,
          side: BorderSide(color: isSelected ? context.primaryColor : AppColors.borderLight),
        ),
      ),
    );
  }
}
