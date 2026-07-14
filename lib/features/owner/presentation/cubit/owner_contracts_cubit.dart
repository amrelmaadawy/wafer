import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contract_item_entity.dart';
import '../../domain/usecases/get_owner_contracts_use_case.dart';
import 'owner_contracts_state.dart';

class OwnerContractsCubit extends Cubit<OwnerContractsState> {
  final GetOwnerContractsUseCase _getContractsUseCase;

  OwnerContractsCubit(this._getContractsUseCase) : super(const OwnerContractsInitial());

  int _currentPage = 1;
  bool _isFetchingNext = false;
  String _currentStatus = 'all';

  String get currentStatus => _currentStatus;

  Future<void> getContracts({bool forceRefresh = false}) async {
    if (forceRefresh || state is! OwnerContractsLoaded) {
      emit(OwnerContractsLoading(activeStatus: _currentStatus));
    }
    _currentPage = 1;

    final result = await _getContractsUseCase(
      GetOwnerContractsParams(
        page: _currentPage,
        status: _currentStatus == 'all' ? null : _currentStatus,
        forceRefresh: forceRefresh,
      ),
    );

    result.fold(
      (failure) => emit(OwnerContractsError(failure.message, activeStatus: _currentStatus)),
      (response) {
        if (response.contracts.isEmpty) {
          emit(OwnerContractsEmpty(activeStatus: _currentStatus));
        } else {
          emit(OwnerContractsLoaded(
            contracts: response.contracts,
            meta: response.meta,
            activeStatus: _currentStatus,
          ));
        }
      },
    );
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! OwnerContractsLoaded || _isFetchingNext || !currentState.meta.hasMore) {
      return;
    }

    _isFetchingNext = true;
    emit(currentState.copyWith(isFetchingMore: true));

    _currentPage = currentState.meta.currentPage + 1;
    final result = await _getContractsUseCase(
      GetOwnerContractsParams(
        page: _currentPage,
        status: _currentStatus == 'all' ? null : _currentStatus,
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
        final updatedList = List<ContractItemEntity>.from(currentState.contracts)
          ..addAll(response.contracts);

        emit(OwnerContractsLoaded(
          contracts: updatedList,
          meta: response.meta,
          activeStatus: _currentStatus,
        ));
      },
    );
  }

  void changeStatusFilter(String newStatus, {bool force = false}) {
    if (!force && _currentStatus == newStatus) return;
    _currentStatus = newStatus;
    getContracts(forceRefresh: true);
  }
}
