import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/contract_status_filter.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import 'contract_status_filter_label.dart';

class ContractsFilterBar extends StatelessWidget {
  const ContractsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      OwnerContractsCubit,
      OwnerContractsState,
      ContractStatusFilter
    >(
      selector: (_) => context.read<OwnerContractsCubit>().currentStatus,
      builder: (context, activeFilter) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: ContractStatusFilter.values
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: _FilterChip(
                      filter: filter,
                      isSelected: filter == activeFilter,
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final ContractStatusFilter filter;
  final bool isSelected;

  const _FilterChip({required this.filter, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(filter.localizedLabel),
      selected: isSelected,
      onSelected: (_) =>
          context.read<OwnerContractsCubit>().changeStatusFilter(filter),
      backgroundColor: context.appSurfaceColor,
      selectedColor: context.primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : context.appOnSurfaceColor,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularFull,
        side: BorderSide(
          color: isSelected ? context.primaryColor : context.appBorderColor,
        ),
      ),
    );
  }
}
