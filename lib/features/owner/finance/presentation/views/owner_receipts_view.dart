import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import '../../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../generated/locale_keys.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
import '../cubit/receipts/finance_receipts_state.dart';
import '../widgets/finance_receipt_card.dart';
import '../widgets/finance_receipts_skeleton.dart';

class OwnerReceiptsView extends StatefulWidget {
  const OwnerReceiptsView({super.key});

  @override
  State<OwnerReceiptsView> createState() => _OwnerReceiptsViewState();
}

class _OwnerReceiptsViewState extends State<OwnerReceiptsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        final state = context.read<FinanceReceiptsCubit>().state;
        if (state is FinanceReceiptsSuccess && !state.hasReachedMax) {
          context.read<FinanceReceiptsCubit>().fetchReceipts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _onSearch(query);
    });
    setState(() {}); // to update suffix icon
  }

  void _onSearch(String query) {
    context
        .read<FinanceReceiptsCubit>()
        .fetchReceipts(isRefresh: true, search: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: Text(LocaleKeys.owner_finance_receipts.tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: LocaleKeys.properties_search_hint.tr(),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondaryLight),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondaryLight),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FinanceReceiptsCubit, FinanceReceiptsState>(
              builder: (context, state) {
                if (state is FinanceReceiptsInitial ||
                    (state is FinanceReceiptsLoading &&
                        context.read<FinanceReceiptsCubit>().state is! FinanceReceiptsPaginationLoading)) {
                  return const FinanceReceiptsSkeleton();
                }

                if (state is FinanceReceiptsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context
                        .read<FinanceReceiptsCubit>()
                        .fetchReceipts(isRefresh: true),
                  );
                }

                var receipts = [];
                bool hasReachedMax = false;
                bool isLoadingMore = false;

                if (state is FinanceReceiptsSuccess) {
                  receipts = state.receipts;
                  hasReachedMax = state.hasReachedMax;
                } else if (state is FinanceReceiptsPaginationLoading) {
                  receipts = state.oldReceipts;
                  isLoadingMore = true;
                }

                if (receipts.isEmpty && !isLoadingMore) {
                  return const CustomEmptyWidget(
                    title: 'لا توجد سندات مالية متاحة',
                    icon: Icons.receipt_long,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: receipts.length + (hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index < receipts.length) {
                        final receipt = receipts[index];
                        return FinanceReceiptCard(receipt: receipt);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
