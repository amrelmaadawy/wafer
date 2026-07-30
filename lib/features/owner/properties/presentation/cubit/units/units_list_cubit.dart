import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_property_units_use_case.dart';
import 'units_list_state.dart';

class UnitsListCubit extends Cubit<UnitsListState> {
  final GetPropertyUnitsUseCase _getPropertyUnitsUseCase;

  UnitsListCubit(this._getPropertyUnitsUseCase)
    : super(const UnitsListInitial());

  Future<void> loadUnits(int propertyId) async {
    emit(const UnitsListLoading());
    final result = await _getPropertyUnitsUseCase(propertyId);

    if (isClosed) return;

    result.fold((failure) => emit(UnitsListError(failure.message)), (data) {
      if (data.items.isEmpty) {
        emit(const UnitsListEmpty());
      } else {
        emit(UnitsListLoaded(units: data.items, meta: data.meta));
      }
    });
  }

  Future<void> loadMore(int propertyId) async {
    if (state is! UnitsListLoaded) return;
    final currentState = state as UnitsListLoaded;

    if (currentState.isFetchingMore || !currentState.meta.hasMore) return;

    emit(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.meta.currentPage + 1;
    final result = await _getPropertyUnitsUseCase(
      propertyId,
      page: nextPage,
      search: currentState.searchQuery,
      unitStatus: currentState.unitStatus,
      unitType: currentState.unitType,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(currentState.copyWith(isFetchingMore: false)),
      (data) {
        emit(
          currentState.copyWith(
            units: [...currentState.units, ...data.items],
            meta: data.meta,
            isFetchingMore: false,
          ),
        );
      },
    );
  }

  Future<void> applyFilter(
    int propertyId, {
    String? search,
    String? unitStatus,
    String? unitType,
  }) async {
    final currentState = state is UnitsListLoaded
        ? state as UnitsListLoaded
        : null;
    final newSearch = search ?? currentState?.searchQuery;
    final newStatus = unitStatus ?? currentState?.unitStatus;
    final newType = unitType ?? currentState?.unitType;

    emit(const UnitsListLoading());
    final result = await _getPropertyUnitsUseCase(
      propertyId,
      page: 1,
      search: newSearch,
      unitStatus: newStatus,
      unitType: newType,
    );

    if (isClosed) return;

    result.fold((failure) => emit(UnitsListError(failure.message)), (data) {
      if (data.items.isEmpty) {
        emit(const UnitsListEmpty());
      } else {
        emit(
          UnitsListLoaded(
            units: data.items,
            meta: data.meta,
            searchQuery: newSearch,
            unitStatus: newStatus,
            unitType: newType,
          ),
        );
      }
    });
  }
}
