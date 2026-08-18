import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_query_filter_entity.dart';
import '../../domain/usecases/get_owner_maintenance_use_case.dart';
import 'maintenance_filter_evaluator.dart';
import 'owner_maintenance_state.dart';

class OwnerMaintenanceCubit extends Cubit<OwnerMaintenanceState> {
  final GetOwnerMaintenanceUseCase _getMaintenanceUseCase;

  OwnerMaintenanceCubit(this._getMaintenanceUseCase)
    : super(const OwnerMaintenanceInitial());

  MaintenanceQueryFilterEntity _currentFilter =
      const MaintenanceQueryFilterEntity();
  List<MaintenanceItemEntity> _allFetchedItems = [];
  dynamic _lastMeta;
  dynamic _lastStats;
  bool _isFetchingNext = false;
  Timer? _debounceTimer;

  MaintenanceQueryFilterEntity get currentFilter => _currentFilter;
  String get currentStatus => _currentFilter.status ?? 'all';
  String? get currentCategory => _currentFilter.typeName;

  Future<void> getMaintenanceRequests({
    bool forceRefresh = false,
    MaintenanceQueryFilterEntity? filter,
  }) async {
    if (filter != null) _currentFilter = filter;
    _currentFilter = _currentFilter.copyWith(page: 1);

    if (forceRefresh || state is! OwnerMaintenanceLoaded) {
      emit(OwnerMaintenanceLoading(activeStatus: currentStatus));
    }

    final apiStatus = _currentFilter.status == 'all'
        ? null
        : _currentFilter.status;

    final result = await _getMaintenanceUseCase(
      GetOwnerMaintenanceParams(
        page: 1,
        status: apiStatus,
        forceRefresh: forceRefresh,
      ),
    );

    result.fold(
      (failure) {
        if (state is! OwnerMaintenanceLoaded) {
          emit(
            OwnerMaintenanceError(failure.message, activeStatus: currentStatus),
          );
        }
      },
      (response) {
        _allFetchedItems = response.items;
        _lastMeta = response.meta;
        _lastStats = response.stats;
        _applyLocalFilterAndEmit(_lastMeta, _lastStats);
      },
    );
  }

  void _applyLocalFilterAndEmit(dynamic meta, dynamic stats) {
    final filtered = MaintenanceFilterEvaluator.evaluate(
      items: _allFetchedItems,
      filter: _currentFilter,
    );

    if (filtered.isEmpty) {
      emit(
        OwnerMaintenanceEmpty(
          activeStatus: currentStatus,
          stats: stats ?? _lastStats,
        ),
      );
    } else {
      emit(
        OwnerMaintenanceLoaded(
          items: filtered,
          meta: meta ?? _lastMeta,
          stats: stats ?? _lastStats,
          activeStatus: currentStatus,
        ),
      );
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! OwnerMaintenanceLoaded ||
        _isFetchingNext ||
        !currentState.meta.hasMore) {
      return;
    }

    _isFetchingNext = true;
    emit(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.meta.currentPage + 1;
    final apiStatus = _currentFilter.status == 'all'
        ? null
        : _currentFilter.status;

    final result = await _getMaintenanceUseCase(
      GetOwnerMaintenanceParams(
        page: nextPage,
        status: apiStatus,
        forceRefresh: false,
      ),
    );

    result.fold(
      (failure) {
        _isFetchingNext = false;
        emit(currentState.copyWith(isFetchingMore: false));
      },
      (response) {
        _isFetchingNext = false;
        final newItems = response.items
            .where((n) => !_allFetchedItems.any((e) => e.safeId == n.safeId))
            .toList();
        _allFetchedItems.addAll(newItems);
        _lastMeta = response.meta;
        _applyLocalFilterAndEmit(
          _lastMeta,
          response.stats ?? currentState.stats,
        );
      },
    );
  }

  void searchMaintenance(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    _currentFilter = _currentFilter.copyWith(
      search: () => trimmed.isNotEmpty ? trimmed : null,
    );
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyLocalFilterAndEmit(_lastMeta, _lastStats);
    });
  }

  void changeStatusFilter(String newStatus, {bool force = false}) {
    if (!force && currentStatus == newStatus) return;
    _currentFilter = _currentFilter.copyWith(status: () => newStatus);
    getMaintenanceRequests(forceRefresh: true);
  }

  void changeCategoryFilter(String? newCategory) {
    _currentFilter = _currentFilter.copyWith(
      typeName: () =>
          newCategory == 'all' || newCategory == null ? null : newCategory,
    );
    _applyLocalFilterAndEmit(_lastMeta, _lastStats);
  }

  void applyAdvancedFilter(MaintenanceQueryFilterEntity filter) {
    _currentFilter = filter;
    _applyLocalFilterAndEmit(_lastMeta, _lastStats);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

