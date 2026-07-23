import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
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
        appBar: CustomAppBar(
          title: LocaleKeys.installmentsTitle.tr(),
          subtitle: contractNumber.isNotEmpty ? contractNumber : null,
        ),
        body: BlocBuilder<OwnerContractInstallmentsCubit, OwnerContractInstallmentsState>(
          builder: (context, state) {
            if (state is OwnerContractInstallmentsLoading || state is OwnerContractInstallmentsInitial) {
              return const InstallmentsSkeletonWidget();
            } else if (state is OwnerContractInstallmentsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<OwnerContractInstallmentsCubit>().getContractInstallments(contractId),
              );
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
}
