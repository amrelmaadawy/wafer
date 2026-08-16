import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/app_pagination_loader.dart';
import '../../../../../../core/utils/widgets/loading_widget.dart';
import 'package:wafer/features/owner/finance/presentation/widgets/finance_payment_card.dart';
import '../../cubit/payments/contract_payments_cubit.dart';
import '../../cubit/payments/contract_payments_state.dart';

class ContractPaymentsTab extends StatefulWidget {
  final int contractId;

  const ContractPaymentsTab({super.key, required this.contractId});

  @override
  State<ContractPaymentsTab> createState() => _ContractPaymentsTabState();
}

class _ContractPaymentsTabState extends State<ContractPaymentsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractPaymentsCubit>().fetchContractPayments(
            contractId: widget.contractId,
            isRefresh: true,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ContractPaymentsCubit>().fetchContractPayments(
            contractId: widget.contractId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractPaymentsCubit, ContractPaymentsState>(
      builder: (context, state) {
        if (state is ContractPaymentsLoading && state.isFirstFetch) {
          return const Center(child: LoadingWidget());
        }

        if (state is ContractPaymentsError && state.oldPayments.isEmpty) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context
                .read<ContractPaymentsCubit>()
                .fetchContractPayments(
                  contractId: widget.contractId,
                  isRefresh: true,
                ),
          );
        }

        if (state is ContractPaymentsEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.contractDetailsNoPayments.tr(),
            subtitle: LocaleKeys.dashboard_no_data.tr(),
          );
        }

        final payments = state is ContractPaymentsLoaded
            ? state.payments
            : (state is ContractPaymentsError ? state.oldPayments : const []);

        if (payments.isEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.contractDetailsNoPayments.tr(),
            subtitle: LocaleKeys.dashboard_no_data.tr(),
          );
        }

        final hasReachedMax =
            state is ContractPaymentsLoaded ? state.hasReachedMax : true;

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<ContractPaymentsCubit>().fetchContractPayments(
                  contractId: widget.contractId,
                  isRefresh: true,
                );
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: payments.length + (hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= payments.length) {
                return const AppPaginationLoader();
              }
              final payment = payments[index];
              return FinancePaymentCard(payment: payment);
            },
          ),
        );
      },
    );
  }
}
