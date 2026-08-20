import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/contract_item_entity.dart';
import '../../../domain/entities/contract_status_filter.dart';
import '../../../domain/entities/contracts_query_filter_entity.dart';
import '../../../domain/usecases/get_owner_contracts_use_case.dart';
import 'owner_contracts_state.dart';

class OwnerContractsCubit extends Cubit<OwnerContractsState> {
  final GetOwnerContractsUseCase _getContractsUseCase;

  OwnerContractsCubit(this._getContractsUseCase)
    : super(const OwnerContractsInitial());

  ContractsQueryFilterEntity _currentFilter = const ContractsQueryFilterEntity();
  List<ContractItemEntity> _allFetchedContracts = [];
  dynamic _lastMeta;
  bool _isFetchingNext = false;
  Timer? _debounceTimer;

  ContractsQueryFilterEntity get currentFilter => _currentFilter;
  ContractStatusFilter get currentStatus => _currentFilter.status;

  Future<void> getContracts({
    bool forceRefresh = false,
    ContractsQueryFilterEntity? filter,
  }) async {
    if (filter != null) _currentFilter = filter;
    _currentFilter = _currentFilter.copyWith(page: 1);

    if (forceRefresh || state is! OwnerContractsLoaded) {
      if (state is OwnerContractsError && forceRefresh) {
        emit((state as OwnerContractsError).copyWith(isRetrying: true));
      } else {
        emit(OwnerContractsLoading(activeStatus: _currentFilter.status));
      }
    }

    final result = await _getContractsUseCase(
      GetOwnerContractsParams(
        page: 1,
        status: _currentFilter.status,
        forceRefresh: forceRefresh,
      ),
    );

    result.fold(
      (failure) => emit(
        OwnerContractsError(failure.message, activeStatus: _currentFilter.status),
      ),
      (response) {
        _allFetchedContracts = response.contracts;
        _lastMeta = response.meta;
        _applyLocalFilterAndEmit(_lastMeta);
      },
    );
  }

  void _applyLocalFilterAndEmit(dynamic meta) {
    List<ContractItemEntity> filtered = List.from(_allFetchedContracts);

    // Filter by search query
    if (_currentFilter.search != null &&
        _currentFilter.search!.trim().isNotEmpty) {
      final query = _currentFilter.search!.trim().toLowerCase();
      filtered = filtered.where((c) {
        return c.contractNumber.toLowerCase().contains(query) ||
            c.propertyName.toLowerCase().contains(query) ||
            c.renterName.toLowerCase().contains(query) ||
            c.unitName.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by property name
    if (_currentFilter.propertyName != null &&
        _currentFilter.propertyName!.trim().isNotEmpty) {
      final pQuery = _currentFilter.propertyName!.trim().toLowerCase();
      filtered = filtered
          .where((c) => c.propertyName.toLowerCase().contains(pQuery))
          .toList();
    }

    // Filter by tenant name
    if (_currentFilter.tenantName != null &&
        _currentFilter.tenantName!.trim().isNotEmpty) {
      final tQuery = _currentFilter.tenantName!.trim().toLowerCase();
      filtered = filtered
          .where((c) => c.renterName.toLowerCase().contains(tQuery))
          .toList();
    }

    // Apply sorting
    if (_currentFilter.sortBy != null) {
      filtered.sort((a, b) {
        int cmp = 0;
        switch (_currentFilter.sortBy!) {
          case ContractSortField.expiryDate:
            cmp = a.endDate.compareTo(b.endDate);
            break;
          case ContractSortField.startDate:
            cmp = a.startDate.compareTo(b.startDate);
            break;
          case ContractSortField.rentAmount:
            cmp = a.totalRentValue.compareTo(b.totalRentValue);
            break;
          case ContractSortField.contractNumber:
            cmp = a.contractNumber.compareTo(b.contractNumber);
            break;
        }
        return _currentFilter.sortAscending ? cmp : -cmp;
      });
    }

    if (filtered.isEmpty) {
      emit(OwnerContractsEmpty(activeStatus: _currentFilter.status));
    } else {
      emit(
        OwnerContractsLoaded(
          contracts: filtered,
          meta: meta ?? _lastMeta,
          activeStatus: _currentFilter.status,
        ),
      );
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! OwnerContractsLoaded ||
        _isFetchingNext ||
        !currentState.meta.hasMore) {
      return;
    }

    _isFetchingNext = true;
    emit(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.meta.currentPage + 1;
    final result = await _getContractsUseCase(
      GetOwnerContractsParams(
        page: nextPage,
        status: _currentFilter.status,
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
        final newItems = response.contracts
            .where((n) => !_allFetchedContracts.any((e) => e.id == n.id))
            .toList();
        _allFetchedContracts.addAll(newItems);
        _lastMeta = response.meta;
        _applyLocalFilterAndEmit(_lastMeta);
      },
    );
  }

  void searchContracts(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    _currentFilter = _currentFilter.copyWith(
      search: () => trimmed.isNotEmpty ? trimmed : null,
    );
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyLocalFilterAndEmit(_lastMeta);
    });
  }

  void changeStatusFilter(ContractStatusFilter newStatus, {bool force = false}) {
    if (!force && _currentFilter.status == newStatus) return;
    _currentFilter = _currentFilter.copyWith(status: newStatus);
    getContracts(forceRefresh: true);
  }

  void applyAdvancedFilter(ContractsQueryFilterEntity filter) {
    _currentFilter = filter;
    _applyLocalFilterAndEmit(_lastMeta);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
