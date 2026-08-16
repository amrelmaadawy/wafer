import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/app_pagination_loader.dart';
import '../../../../../../core/utils/widgets/loading_widget.dart';
import 'package:wafer/features/owner/finance/presentation/widgets/finance_payment_card.dart';
import '../../cubit/property_finance/property_finance_cubit.dart';
import '../../cubit/property_finance/property_finance_state.dart';

class PropertyFinanceTab extends StatefulWidget {
  final int propertyId;

  const PropertyFinanceTab({super.key, required this.propertyId});

  @override
  State<PropertyFinanceTab> createState() => _PropertyFinanceTabState();
}

class _PropertyFinanceTabState extends State<PropertyFinanceTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyFinanceCubit>().fetchPropertyPayments(
            propertyId: widget.propertyId,
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
      context.read<PropertyFinanceCubit>().fetchPropertyPayments(
            propertyId: widget.propertyId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyFinanceCubit, PropertyFinanceState>(
      builder: (context, state) {
        if (state is PropertyFinanceLoading && state.isFirstFetch) {
          return const Center(child: LoadingWidget());
        }

        if (state is PropertyFinanceError && state.oldPayments.isEmpty) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context
                .read<PropertyFinanceCubit>()
                .fetchPropertyPayments(
                  propertyId: widget.propertyId,
                  isRefresh: true,
                ),
          );
        }

        if (state is PropertyFinanceEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.propertyDetailsNoFinance.tr(),
            subtitle: LocaleKeys.propertyDetailsNoFinanceSubtitle.tr(),
          );
        }

        final payments = state is PropertyFinanceLoaded
            ? state.payments
            : (state is PropertyFinanceError ? state.oldPayments : const []);

        if (payments.isEmpty) {
          return CustomEmptyWidget(
            icon: Icons.account_balance_wallet_outlined,
            title: LocaleKeys.propertyDetailsNoFinance.tr(),
            subtitle: LocaleKeys.propertyDetailsNoFinanceSubtitle.tr(),
          );
        }

        final hasReachedMax =
            state is PropertyFinanceLoaded ? state.hasReachedMax : true;

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<PropertyFinanceCubit>().fetchPropertyPayments(
                  propertyId: widget.propertyId,
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
