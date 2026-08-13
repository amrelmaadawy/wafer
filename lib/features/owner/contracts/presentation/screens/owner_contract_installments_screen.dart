import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/installments/owner_contract_installments_cubit.dart';
import '../cubit/installments/owner_contract_installments_state.dart';
import '../widgets/installments/installments_content.dart';
import '../widgets/installments/installments_empty_widget.dart';
import '../widgets/installments/installments_skeleton_widget.dart';

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
      create: (_) =>
          di.sl<OwnerContractInstallmentsCubit>()
            ..getContractInstallments(contractId),
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.installmentsTitle.tr(),
          subtitle: contractNumber.isEmpty ? null : contractNumber,
        ),
        body:
            BlocBuilder<
              OwnerContractInstallmentsCubit,
              OwnerContractInstallmentsState
            >(
              builder: (context, state) {
                if (state is OwnerContractInstallmentsLoading ||
                    state is OwnerContractInstallmentsInitial) {
                  return const InstallmentsSkeletonWidget();
                }
                if (state is OwnerContractInstallmentsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context
                        .read<OwnerContractInstallmentsCubit>()
                        .getContractInstallments(contractId),
                  );
                }
                if (state is! OwnerContractInstallmentsLoaded) {
                  return const SizedBox.shrink();
                }
                if (state.allInstallments.isEmpty) {
                  return const InstallmentsEmptyWidget();
                }
                return RefreshIndicator(
                  color: context.primaryColor,
                  onRefresh: () => context
                      .read<OwnerContractInstallmentsCubit>()
                      .getContractInstallments(contractId),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20, bottom: 80),
                    child: AppResponsiveContent(
                      child: InstallmentsContent(state: state),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
