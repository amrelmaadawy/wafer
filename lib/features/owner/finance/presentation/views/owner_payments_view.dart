import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/filter_sort_header_bar.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/payment_entity.dart';
import '../cubit/payments/cancel_finance_payment_cubit.dart';
import '../cubit/payments/cancel_finance_payment_state.dart';
import '../cubit/payments/finance_payments_cubit.dart';
import '../cubit/payments/finance_payments_state.dart';
import '../widgets/cancel_payment_dialog.dart';
import '../widgets/finance_filter_sheet.dart';
import '../widgets/finance_payment_card.dart';
import '../widgets/finance_payments_skeleton.dart';
import '../widgets/finance_sort_sheet.dart';

class OwnerPaymentsView extends StatefulWidget {
  const OwnerPaymentsView({super.key});

  @override
  State<OwnerPaymentsView> createState() => _OwnerPaymentsViewState();
}

class _OwnerPaymentsViewState extends State<OwnerPaymentsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<FinancePaymentsCubit>();
    if (cubit.state is FinancePaymentsInitial) {
      cubit.fetchPayments();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<FinancePaymentsCubit>().fetchPayments(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FinancePaymentsCubit>();
    final filter = cubit.currentFilter;

    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          LocaleKeys.owner_finance_payment_vouchers.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: context.appBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () async {
          final result = await context.push(Routes.ownerFinanceCreatePayment);
          if (result == true && mounted) _onRefresh();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CancelFinancePaymentCubit, CancelFinancePaymentState>(
            listener: (context, cancelState) {
              if (cancelState is CancelFinancePaymentLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (cancelState is CancelFinancePaymentSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                AppToast.showSuccess(
                  context,
                  LocaleKeys.ownerFinanceCancelPaymentSuccess.tr(),
                );
                _onRefresh();
              } else if (cancelState is CancelFinancePaymentError) {
                Navigator.of(context, rootNavigator: true).pop();
                AppToast.showError(context, cancelState.message);
              }
            },
          ),
        ],
        child: Column(
          children: [
            FilterSortHeaderBar(
              searchField: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.propertiesSearchHint,
                initialValue: filter.search,
                onChanged: (val) =>
                    cubit.fetchPayments(isRefresh: true, search: val),
                onClear: () =>
                    cubit.fetchPayments(isRefresh: true, search: ''),
              ),
              activeFiltersCount: filter.activeFiltersCount,
              isSortActive: filter.isSortActive,
              onFilterTap: () => FinanceFilterSheet.show(
                context,
                currentFilter: filter,
                onApply: cubit.applyFilter,
              ),
              onSortTap: () => FinanceSortSheet.show(
                context,
                currentFilter: filter,
                onApply: cubit.applyFilter,
              ),
            ),
            Expanded(
              child: BlocConsumer<FinancePaymentsCubit, FinancePaymentsState>(
                listener: (context, state) {
                  if (state is FinancePaymentsError &&
                      state.oldPayments.isNotEmpty) {
                    AppToast.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is FinancePaymentsInitial ||
                      (state is FinancePaymentsLoading && state.isFirstFetch)) {
                    return const FinancePaymentsSkeleton();
                  }

                  if (state is FinancePaymentsError &&
                      state.oldPayments.isEmpty) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: _onRefresh,
                    );
                  }

                  final payments = state is FinancePaymentsLoaded
                      ? state.payments
                      : state is FinancePaymentsError
                          ? state.oldPayments
                          : const <PaymentEntity>[];

                  final hasReachedMax = state is FinancePaymentsLoaded
                      ? state.hasReachedMax
                      : true;

                  return PaginatedListView<PaymentEntity>(
                    items: payments,
                    isFetchingMore: state is FinancePaymentsLoading &&
                        !state.isFirstFetch,
                    hasReachedMax: hasReachedMax,
                    useStaggeredAnimation: true,
                    onRefresh: _onRefresh,
                    onLoadMore: () => cubit.fetchPayments(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    emptyWidget: CustomEmptyWidget(
                      icon: Icons.payments_outlined,
                      title: LocaleKeys.noMatchingFilterResults.tr(),
                      subtitle: '',
                    ),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index, payment) {
                      return FinancePaymentCard(
                        payment: payment,
                        onTap: () => context.push(
                          Routes.ownerFinancePaymentDetails.replaceFirst(
                            ':id',
                            payment.id.toString(),
                          ),
                        ),
                        onEditTap: () => context.push(
                          Routes.ownerFinancePaymentUpdate,
                          extra: {'cubit': cubit, 'payment': payment},
                        ),
                        onCancelTap: () => _showCancelDialog(context, payment),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, PaymentEntity payment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CancelPaymentDialog(
        onConfirm: (reason) {
          context
              .read<CancelFinancePaymentCubit>()
              .cancelPayment(payment.id, reason);
        },
      ),
    );
  }
}
