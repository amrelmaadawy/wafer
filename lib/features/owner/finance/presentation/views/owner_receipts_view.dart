import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
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
import '../../domain/entities/receipt_entity.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
import '../cubit/receipts/finance_receipts_state.dart';
import '../widgets/finance_filter_sheet.dart';
import '../widgets/finance_receipt_card.dart';
import '../widgets/finance_receipts_skeleton.dart';
import '../widgets/finance_sort_sheet.dart';

class OwnerReceiptsView extends StatefulWidget {
  const OwnerReceiptsView({super.key});

  @override
  State<OwnerReceiptsView> createState() => _OwnerReceiptsViewState();
}

class _OwnerReceiptsViewState extends State<OwnerReceiptsView> {
  @override
  void initState() {
    super.initState();
    context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FinanceReceiptsCubit>();
    final filter = cubit.currentFilter;

    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: Text(LocaleKeys.owner_finance_receipts.tr()),
        backgroundColor: context.appBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            Routes.ownerFinanceReceiptCreate,
            extra: context.read<FinanceReceiptsCubit>(),
          );
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          FilterSortHeaderBar(
            searchField: UnifiedSearchField(
              hintLocaleKey: LocaleKeys.propertiesSearchHint,
              initialValue: filter.search,
              onChanged: (val) =>
                  cubit.fetchReceipts(isRefresh: true, search: val),
              onClear: () => cubit.fetchReceipts(isRefresh: true, search: ''),
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
            child: BlocConsumer<FinanceReceiptsCubit, FinanceReceiptsState>(
              listener: (context, state) {
                if (state is FinanceReceiptsError &&
                    state.oldReceipts.isNotEmpty) {
                  AppToast.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is FinanceReceiptsInitial ||
                    (state is FinanceReceiptsLoading &&
                        context.read<FinanceReceiptsCubit>().state
                            is! FinanceReceiptsPaginationLoading)) {
                  return const FinanceReceiptsSkeleton();
                }

                if (state is FinanceReceiptsError && state.oldReceipts.isEmpty) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => cubit.fetchReceipts(isRefresh: true),
                  );
                }

                List<ReceiptEntity> receipts = [];
                bool hasReachedMax = false;
                bool isFetchingMore = false;

                if (state is FinanceReceiptsSuccess) {
                  receipts = state.receipts;
                  hasReachedMax = state.hasReachedMax;
                } else if (state is FinanceReceiptsPaginationLoading) {
                  receipts = state.oldReceipts;
                  isFetchingMore = true;
                } else if (state is FinanceReceiptsError) {
                  receipts = state.oldReceipts;
                }

                return PaginatedListView<ReceiptEntity>(
                  items: receipts,
                  isFetchingMore: isFetchingMore,
                  hasReachedMax: hasReachedMax,
                  useStaggeredAnimation: true,
                  onRefresh: () => cubit.fetchReceipts(isRefresh: true),
                  onLoadMore: () => cubit.fetchReceipts(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  emptyWidget: CustomEmptyWidget(
                    title: LocaleKeys.noMatchingFilterResults.tr(),
                    icon: Icons.receipt_long,
                  ),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index, receipt) {
                    return FinanceReceiptCard(
                      receipt: receipt,
                      onTap: () {
                        context.push(
                          Routes.ownerFinanceReceiptDetails.replaceFirst(
                            ':id',
                            receipt.id.toString(),
                          ),
                          extra: cubit,
                        );
                      },
                      onEditTap: () {
                        context.push(
                          Routes.ownerFinanceReceiptUpdate,
                          extra: {'cubit': cubit, 'receipt': receipt},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
