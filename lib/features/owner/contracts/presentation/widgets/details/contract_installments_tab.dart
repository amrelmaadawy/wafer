import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../cubit/installments/owner_contract_installments_cubit.dart';
import '../../cubit/installments/owner_contract_installments_state.dart';
import '../installments/installments_content.dart';
import '../installments/installments_empty_widget.dart';
import '../installments/installments_skeleton_widget.dart';

class ContractInstallmentsTab extends StatefulWidget {
  final String contractId;

  const ContractInstallmentsTab({super.key, required this.contractId});

  @override
  State<ContractInstallmentsTab> createState() =>
      _ContractInstallmentsTabState();
}

class _ContractInstallmentsTabState extends State<ContractInstallmentsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<OwnerContractInstallmentsCubit>()
          .getContractInstallments(widget.contractId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
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
                .getContractInstallments(widget.contractId),
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
              .getContractInstallments(widget.contractId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: AppResponsiveContent(
              child: InstallmentsContent(state: state),
            ),
          ),
        );
      },
    );
  }
}
