import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../../domain/entities/property_list_item_entity.dart';
import '../../../domain/usecases/get_properties_list_use_case.dart';
import 'properties_list_state.dart';

class PropertiesListCubit extends Cubit<PropertiesListState> {
  final GetPropertiesListUseCase _getPropertiesListUseCase;

  PropertiesListCubit(this._getPropertiesListUseCase)
      : super(const PropertiesListInitial());

  PropertiesQueryFilterEntity _currentFilter = const PropertiesQueryFilterEntity();
  List<PropertyListItemEntity> _allFetchedProperties = [];
  dynamic _lastMeta;
  dynamic _lastStats;
  Timer? _debounceTimer;

  PropertiesQueryFilterEntity get currentFilter => _currentFilter;

  Future<void> getProperties({
    bool forceRefresh = false,
    PropertiesQueryFilterEntity? filter,
  }) async {
    if (filter != null) _currentFilter = filter;
    _currentFilter = _currentFilter.copyWith(page: 1);

    if (state is! PropertiesListLoaded || forceRefresh) {
      emit(const PropertiesListLoading());
    }

    final result = await _getPropertiesListUseCase(filter: _currentFilter);

    result.fold(
      (failure) => emit(PropertiesListError(failure.message)),
      (data) {
        _allFetchedProperties = data.items;
        _lastMeta = data.meta;
        _lastStats = data.stats;
        _applyLocalFilterAndEmit(_lastMeta, _lastStats);
      },
    );
  }

  void _applyLocalFilterAndEmit(dynamic meta, dynamic stats) {
    List<PropertyListItemEntity> filtered = List.from(_allFetchedProperties);

    // Apply status filter locally if specified
    if (_currentFilter.status != null &&
        _currentFilter.status != 'all' &&
        _currentFilter.status!.isNotEmpty) {
      final statusLower = _currentFilter.status!.toLowerCase();
      filtered = filtered.where((p) => p.status.toLowerCase() == statusLower).toList();
    }

    // Apply search filter locally if specified
    if (_currentFilter.search != null && _currentFilter.search!.trim().isNotEmpty) {
      final query = _currentFilter.search!.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.code.toLowerCase().contains(query) ||
            p.displayAddress.toLowerCase().contains(query);
      }).toList();
    }

    if (filtered.isEmpty) {
      emit(PropertiesListEmpty(filter: _currentFilter));
    } else {
      emit(PropertiesListLoaded(
        properties: filtered,
        meta: meta,
        stats: stats,
        filter: _currentFilter,
      ));
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! PropertiesListLoaded ||
        currentState.isFetchingMore ||
        !currentState.meta.hasMore) {
      return;
    }

    emit(currentState.copyWith(isFetchingMore: true));
    final nextPageFilter = _currentFilter.copyWith(page: _currentFilter.page + 1);

    final result = await _getPropertiesListUseCase(filter: nextPageFilter);

    result.fold(
      (failure) => emit(currentState.copyWith(isFetchingMore: false)),
      (data) {
        _currentFilter = nextPageFilter;
        _allFetchedProperties.addAll(data.items);
        _lastMeta = data.meta;
        _applyLocalFilterAndEmit(_lastMeta, _lastStats);
      },
    );
  }

  void changeStatusFilter(String statusFilter) {
    _currentFilter = _currentFilter.copyWith(
      status: () => statusFilter == 'all' ? null : statusFilter,
    );

    if (_allFetchedProperties.isNotEmpty && _lastMeta != null) {
      _applyLocalFilterAndEmit(_lastMeta, _lastStats);
    } else {
      getProperties(filter: _currentFilter, forceRefresh: false);
    }
  }

  void searchProperties(String query) {
    _debounceTimer?.cancel();
    
    final trimmedQuery = query.trim();
    final isSearching = trimmedQuery.isNotEmpty;

    _currentFilter = _currentFilter.copyWith(
      search: () => isSearching ? trimmedQuery : null,
      // Automatically switch to 'All' category when searching globally
      status: () => isSearching ? null : _currentFilter.status,
    );

    if (_allFetchedProperties.isNotEmpty && _lastMeta != null) {
      _applyLocalFilterAndEmit(_lastMeta, _lastStats);
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        getProperties(filter: _currentFilter, forceRefresh: false);
      });
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
