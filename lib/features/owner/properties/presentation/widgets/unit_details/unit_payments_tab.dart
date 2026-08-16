import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/app_pagination_loader.dart';
import '../../../../../../core/utils/widgets/loading_widget.dart';
import 'package:wafer/features/owner/finance/presentation/widgets/finance_payment_card.dart';
import '../../cubit/unit_payments/unit_payments_cubit.dart';
import '../../cubit/unit_payments/unit_payments_state.dart';

class UnitPaymentsTab extends StatefulWidget {
  final int unitId;

  const UnitPaymentsTab({super.key, required this.unitId});

  @override
  State<UnitPaymentsTab> createState() => _UnitPaymentsTabState();
}

class _UnitPaymentsTabState extends State<UnitPaymentsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnitPaymentsCubit>().fetchUnitPayments(
            unitId: widget.unitId,
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
      context.read<UnitPaymentsCubit>().fetchUnitPayments(
            unitId: widget.unitId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitPaymentsCubit, UnitPaymentsState>(
      builder: (context, state) {
        if (state is UnitPaymentsLoading && state.isFirstFetch) {
          return const Center(child: LoadingWidget());
        }

        if (state is UnitPaymentsError && state.oldPayments.isEmpty) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<UnitPaymentsCubit>().fetchUnitPayments(
                  unitId: widget.unitId,
                  isRefresh: true,
                ),
          );
        }

        if (state is UnitPaymentsEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.unitDetailsNoPayments.tr(),
            subtitle: LocaleKeys.dashboard_no_data.tr(),
          );
        }

        final payments = state is UnitPaymentsLoaded
            ? state.payments
            : (state is UnitPaymentsError ? state.oldPayments : const []);

        if (payments.isEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.unitDetailsNoPayments.tr(),
            subtitle: LocaleKeys.dashboard_no_data.tr(),
          );
        }

        final hasReachedMax =
            state is UnitPaymentsLoaded ? state.hasReachedMax : true;

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<UnitPaymentsCubit>().fetchUnitPayments(
                  unitId: widget.unitId,
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
