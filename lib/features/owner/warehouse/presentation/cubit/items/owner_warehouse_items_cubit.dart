import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_owner_warehouse_items_use_case.dart';
import 'owner_warehouse_items_state.dart';

class OwnerWarehouseItemsCubit extends Cubit<OwnerWarehouseItemsState> {
  final GetOwnerWarehouseItemsUseCase getItemsUseCase;

  // Filter states
  String? _searchQuery;
  String? _category;
  int? _warehouseId;
  String? _status;

  OwnerWarehouseItemsCubit({required this.getItemsUseCase})
      : super(const OwnerWarehouseItemsInitial());

  Future<void> fetchItems({bool isRefresh = false}) async {
    if (state is OwnerWarehouseItemsLoading && !isRefresh) return;
    
    // Determine the page to request
    int page = 1;
    if (!isRefresh && state is OwnerWarehouseItemsLoaded) {
      if (state.hasReachedMax) return;
      page = state.currentPage + 1;
    }

    emit(OwnerWarehouseItemsLoading(
      items: isRefresh ? const [] : state.items,
      currentPage: isRefresh ? 1 : state.currentPage,
      hasReachedMax: isRefresh ? false : state.hasReachedMax,
    ));

    final result = await getItemsUseCase(
      GetOwnerWarehouseItemsParams(
        page: page,
        search: _searchQuery,
        category: _category,
        warehouseId: _warehouseId,
        status: _status,
      ),
    );

    result.fold(
      (failure) {
        emit(OwnerWarehouseItemsError(
          message: failure.message,
          items: state.items,
          currentPage: state.currentPage,
          hasReachedMax: state.hasReachedMax,
        ));
      },
      (response) {
        final newItems = response.items;
        final pagination = response.pagination;
        final bool hasReachedMax = pagination.currentPage >= pagination.lastPage;

        emit(OwnerWarehouseItemsLoaded(
          items: isRefresh ? newItems : [...state.items, ...newItems],
          currentPage: pagination.currentPage,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
  }

  void updateFilters({
    String? search,
    String? category,
    int? warehouseId,
    String? status,
  }) {
    _searchQuery = search;
    _category = category;
    _warehouseId = warehouseId;
    _status = status;
    fetchItems(isRefresh: true);
  }

  void clearFilters() {
    _searchQuery = null;
    _category = null;
    _warehouseId = null;
    _status = null;
    fetchItems(isRefresh: true);
  }
}
