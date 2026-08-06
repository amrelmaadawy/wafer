import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../cubit/payments/finance_payments_cubit.dart';
import '../cubit/payments/finance_payments_state.dart';
import '../widgets/finance_payment_card.dart';
import '../widgets/finance_payments_skeleton.dart';

class OwnerPaymentsView extends StatefulWidget {
  const OwnerPaymentsView({super.key});

  @override
  State<OwnerPaymentsView> createState() => _OwnerPaymentsViewState();
}

class _OwnerPaymentsViewState extends State<OwnerPaymentsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final cubit = context.read<FinancePaymentsCubit>();
    if (cubit.state is FinancePaymentsInitial) {
      cubit.fetchPayments();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FinancePaymentsCubit>().fetchPayments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<FinancePaymentsCubit>().fetchPayments(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
       scrolledUnderElevation: 0,
        title: Text(
          LocaleKeys.owner_finance_payment_vouchers.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: BlocBuilder<FinancePaymentsCubit, FinancePaymentsState>(
          builder: (context, state) {
            if (state is FinancePaymentsInitial ||
                (state is FinancePaymentsLoading && state.isFirstFetch)) {
              return const FinancePaymentsSkeleton();
            } else if (state is FinancePaymentsEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: CustomEmptyWidget(
                    icon: Icons.payments_outlined,
                    title: LocaleKeys.no_data_available.tr(),
                    subtitle: '',
                  ),
                ),
              );
            } else if (state is FinancePaymentsError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: CustomErrorWidget(
                    message: state.message,
                    onRetry: _onRefresh,
                  ),
                ),
              );
            }

            final payments = state is FinancePaymentsLoaded
                ? state.payments
                : (context.read<FinancePaymentsCubit>().state
                        as FinancePaymentsLoaded?)
                    ?.payments ??
                    [];

            final hasReachedMax = state is FinancePaymentsLoaded
                ? state.hasReachedMax
                : (context.read<FinancePaymentsCubit>().state
                        as FinancePaymentsLoaded?)
                    ?.hasReachedMax ??
                    true;

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: payments.length + (hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < payments.length) {
                  return FinancePaymentCard(
                    payment: payments[index],
                    onTap: () {
                      // TODO: Navigate to payment details if needed
                    },
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () {
          context.push(Routes.ownerFinanceCreatePayment);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
