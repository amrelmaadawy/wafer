import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/deed_entity.dart';
import '../../../domain/entities/deeds_query_filter_entity.dart';
import '../../../domain/usecases/get_deeds_use_case.dart';
import 'deeds_list_state.dart';

class DeedsListCubit extends Cubit<DeedsListState> {
  final GetDeedsUseCase _getDeedsUseCase;

  DeedsListCubit(this._getDeedsUseCase) : super(const DeedsListInitial());

  DeedsQueryFilterEntity _currentFilter = const DeedsQueryFilterEntity();
  List<DeedEntity> _allFetchedDeeds = [];
  Timer? _debounceTimer;
  dynamic _lastMeta;

  DeedsQueryFilterEntity get currentFilter => _currentFilter;

  Future<void> getDeeds({
    bool forceRefresh = false,
    DeedsQueryFilterEntity? filter,
  }) async {
    if (filter != null) _currentFilter = filter;
    _currentFilter = _currentFilter.copyWith(page: 1);

    if (state is! DeedsListLoaded || forceRefresh) {
      emit(const DeedsListLoading());
    }

    final result = await _getDeedsUseCase(filter: _currentFilter);

    result.fold(
      (failure) => emit(DeedsListError(failure.message)),
      (data) {
        _allFetchedDeeds = data.items;
        _lastMeta = data.meta;
        _emitSuccessOrEmpty();
      },
    );
  }

  void _emitSuccessOrEmpty() {
    if (_allFetchedDeeds.isEmpty) {
      emit(DeedsListEmpty(filter: _currentFilter));
    } else {
      emit(DeedsListLoaded(
        deeds: _allFetchedDeeds,
        meta: _lastMeta,
        filter: _currentFilter,
      ));
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! DeedsListLoaded || currentState.isFetchingMore || !currentState.meta.hasMore) {
      return;
    }

    emit(currentState.copyWith(isFetchingMore: true));
    final nextPageFilter = _currentFilter.copyWith(page: _currentFilter.page + 1);

    final result = await _getDeedsUseCase(filter: nextPageFilter);

    result.fold(
      (failure) => emit(currentState.copyWith(isFetchingMore: false)),
      (data) {
        _currentFilter = nextPageFilter;
        _allFetchedDeeds.addAll(data.items);
        _lastMeta = data.meta;
        _emitSuccessOrEmpty();
      },
    );
  }

  void searchDeeds(String query) {
    _debounceTimer?.cancel();
    
    final trimmedQuery = query.trim();
    final isSearching = trimmedQuery.isNotEmpty;

    _currentFilter = _currentFilter.copyWith(
      search: () => isSearching ? trimmedQuery : null,
      branchId: () => isSearching ? null : _currentFilter.branchId, // Reset branch filter on search
      page: 1, // Reset pagination on search
    );

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      getDeeds(filter: _currentFilter, forceRefresh: true);
    });
  }

  void filterByBranch(int? branchId) {
    _currentFilter = _currentFilter.copyWith(
      branchId: () => branchId,
      page: 1, // Reset pagination on filter
    );
    getDeeds(filter: _currentFilter, forceRefresh: true);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
