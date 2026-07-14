import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../cubit/installments/owner_contract_installments_cubit.dart';
import '../cubit/installments/owner_contract_installments_state.dart';
import '../widgets/installments/installment_card.dart';
import '../widgets/installments/installments_empty_widget.dart';
import '../widgets/installments/installments_filter_bar.dart';
import '../widgets/installments/installments_skeleton_widget.dart';
import '../widgets/installments/installments_summary_card.dart';

class OwnerContractInstallmentsScreen extends StatelessWidget {
  final String contractId;
  final String contractNumber;

  const OwnerContractInstallmentsScreen({
    super.key,
    required this.contractId,
    this.contractNumber = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OwnerContractInstallmentsCubit>()..getContractInstallments(contractId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
          title: Column(
            children: [
              Text(
                LocaleKeys.installmentsTitle.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (contractNumber.isNotEmpty)
                Text(
                  contractNumber,
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        body: BlocBuilder<OwnerContractInstallmentsCubit, OwnerContractInstallmentsState>(
          builder: (context, state) {
            if (state is OwnerContractInstallmentsLoading || state is OwnerContractInstallmentsInitial) {
              return const InstallmentsSkeletonWidget();
            } else if (state is OwnerContractInstallmentsError) {
              return _buildErrorState(context, state.message);
            } else if (state is OwnerContractInstallmentsLoaded) {
              final all = state.allInstallments;
              if (all.isEmpty) return const InstallmentsEmptyWidget();
              final filtered = state.filteredInstallments;
              return RefreshIndicator(
                color: context.primaryColor,
                onRefresh: () =>
                    context.read<OwnerContractInstallmentsCubit>().getContractInstallments(contractId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  children: [
                    InstallmentsSummaryCard(installments: all),
                    const SizedBox(height: 16),
                    InstallmentsFilterBar(activeFilter: state.activeFilter),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: filtered.isEmpty
                          ? const Padding(
                              key: ValueKey('empty'),
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: InstallmentsEmptyWidget(),
                            )
                          : Column(
                              key: ValueKey(state.activeFilter),
                              children: filtered
                                  .map((inst) => Padding(
                                        padding: const EdgeInsets.only(bottom: 14),
                                        child: InstallmentCard(installment: inst),
                                      ))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: LocaleKeys.commonRetry.tr(),
              width: 150,
              onPressed: () =>
                  context.read<OwnerContractInstallmentsCubit>().getContractInstallments(contractId),
            ),
          ],
        ),
      ),
    );
  }
}
