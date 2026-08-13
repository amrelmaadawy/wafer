import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/installment_status_filter.dart';
import '../../cubit/installments/owner_contract_installments_cubit.dart';

class InstallmentsFilterBar extends StatelessWidget {
  final InstallmentStatusFilter activeFilter;

  const InstallmentsFilterBar({super.key, required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: context.appBorderColor),
      ),
      child: Row(
        children: InstallmentStatusFilter.values
            .map(
              (filter) => _SegmentButton(
                filter: filter,
                isSelected: filter == activeFilter,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final InstallmentStatusFilter filter;
  final bool isSelected;

  const _SegmentButton({required this.filter, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => context
            .read<OwnerContractInstallmentsCubit>()
            .filterInstallments(filter),
        borderRadius: AppRadius.circularMd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : Colors.transparent,
            borderRadius: AppRadius.circularMd,
          ),
          child: Text(
            _label.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : context.appSecondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }

  String get _label => switch (filter) {
    InstallmentStatusFilter.all => LocaleKeys.installmentsFilterAll,
    InstallmentStatusFilter.paid => LocaleKeys.installmentsFilterPaid,
    InstallmentStatusFilter.unpaid => LocaleKeys.installmentsFilterUnpaid,
  };
}
