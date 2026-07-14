import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../cubit/owner_contract_installments_cubit.dart';

class InstallmentsFilterBar extends StatelessWidget {
  final String activeFilter;

  const InstallmentsFilterBar({super.key, required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          _buildSegmentBtn(context, 'all', LocaleKeys.installmentsFilterAll.tr()),
          _buildSegmentBtn(context, 'paid', LocaleKeys.installmentsFilterPaid.tr()),
          _buildSegmentBtn(context, 'unpaid', LocaleKeys.installmentsFilterUnpaid.tr()),
        ],
      ),
    );
  }

  Widget _buildSegmentBtn(BuildContext context, String key, String label) {
    final isSelected = activeFilter == key;
    final primaryColor = context.primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<OwnerContractInstallmentsCubit>().filterInstallments(key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: AppRadius.circularSm,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}
