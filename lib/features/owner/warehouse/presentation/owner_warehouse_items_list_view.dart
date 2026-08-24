import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'cubit/items/owner_warehouse_items_cubit.dart';
import 'cubit/items/owner_warehouse_items_state.dart';
import 'widgets/warehouse_item_list_card.dart';

class OwnerWarehouseItemsListView extends StatefulWidget {
  const OwnerWarehouseItemsListView({super.key});

  @override
  State<OwnerWarehouseItemsListView> createState() =>
      _OwnerWarehouseItemsListViewState();
}

class _OwnerWarehouseItemsListViewState
    extends State<OwnerWarehouseItemsListView> {
  late final OwnerWarehouseItemsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerWarehouseItemsCubit>()..fetchItems();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onSearch(String query) {
    _cubit.updateFilters(search: query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.warehouse_dashboard_title.tr(), // Or a dedicated key
          showBackButton: true,
          onBackPressed: () => context.pop(),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.warehouse_search_hint,
                onChanged: _onSearch,
                onClear: () => _onSearch(''),
              ),
            ),
            Expanded(
              child: BlocBuilder<OwnerWarehouseItemsCubit, OwnerWarehouseItemsState>(
                builder: (context, state) {
                  final isLoading = state is OwnerWarehouseItemsLoading;
                  final isFetchingMore =
                      isLoading && state.items.isNotEmpty;
                  final isFirstLoad = isLoading && state.items.isEmpty;

                  if (state is OwnerWarehouseItemsError && state.items.isEmpty) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () => _cubit.fetchItems(isRefresh: true),
                    );
                  }

                  return PaginatedListView(
                    items: state.items,
                    isLoading: isFirstLoad,
                    isFetchingMore: isFetchingMore,
                    hasReachedMax: state.hasReachedMax,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    onRefresh: () async {
                      await _cubit.fetchItems(isRefresh: true);
                    },
                    onLoadMore: () {
                      _cubit.fetchItems();
                    },
                    emptyWidget: CustomEmptyWidget(
                      icon: Icons.inventory_2_outlined,
                      title: LocaleKeys.warehouse_items_empty.tr(),
                      subtitle: LocaleKeys.warehouse_items_empty_sub.tr(),
                    ),
                    itemBuilder: (context, index, item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: WarehouseItemListCard(item: item),
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
}
