import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/translations/locale_keys.g.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/presentation/widgets/app_confirm_dialog.dart';
import 'cubit/delete_item/delete_owner_warehouse_item_cubit.dart';
import 'cubit/delete_item/delete_owner_warehouse_item_state.dart';

import 'cubit/items/owner_warehouse_items_cubit.dart';
import 'cubit/items/owner_warehouse_items_state.dart';
import 'widgets/warehouse_items_shimmer.dart';
import '../../shell/presentation/widgets/owner_top_app_bar.dart';
import '../domain/entities/warehouse_item_entity.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider(create: (context) => sl<DeleteOwnerWarehouseItemCubit>()),
      ],
      child: BlocListener<DeleteOwnerWarehouseItemCubit, DeleteOwnerWarehouseItemState>(
        listener: (context, state) {
          if (state is DeleteOwnerWarehouseItemSuccess) {
            AppToast.showSuccess(context, LocaleKeys.warehouse_item_deleted_success.tr());
            _cubit.fetchItems(isRefresh: true);
          } else if (state is DeleteOwnerWarehouseItemError) {
            AppToast.showError(context, state.message);
          }
        },
        child: Scaffold(
        appBar: OwnerTopAppBar(
          title: LocaleKeys.warehouse_items_list_title.tr(),
          showDrawerButton: true,
          forceDrawerButton: true,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: context.primaryColor,
          elevation: 4,
          onPressed: () {
            context.push(Routes.ownerWarehouseItemCreate).then((newItem) {
              if (newItem != null && newItem is WarehouseItemEntity) {
                _cubit.addItemToTop(newItem);
              }
            });
          },
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
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
              child:
                  BlocBuilder<
                    OwnerWarehouseItemsCubit,
                    OwnerWarehouseItemsState
                  >(
                    builder: (context, state) {
                      final isLoading = state is OwnerWarehouseItemsLoading;
                      final isFetchingMore =
                          isLoading && state.items.isNotEmpty;
                      final isFirstLoad = isLoading && state.items.isEmpty;

                      if (state is OwnerWarehouseItemsError &&
                          state.items.isEmpty) {
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
                        loadingWidget: const WarehouseItemsShimmer(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
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
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: WarehouseItemListCard(
                              item: item,
                              onEdit: () {
                                context.push('${Routes.ownerWarehouseItemDetails}/${item.id}');
                              },
                              onDelete: () async {
                                final confirm = await AppConfirmDialog.show(
                                  context: context,
                                  titleKey: LocaleKeys.warehouse_delete_item_title,
                                  messageKey: LocaleKeys.warehouse_delete_item_message,
                                );
                                if (confirm == true && context.mounted) {
                                  context.read<DeleteOwnerWarehouseItemCubit>().deleteItem(item.id);
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
