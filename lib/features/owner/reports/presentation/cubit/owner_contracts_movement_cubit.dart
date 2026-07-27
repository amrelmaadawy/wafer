import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_contracts_movement_report_use_case.dart';
import 'owner_contracts_movement_state.dart';

class OwnerContractsMovementCubit extends Cubit<OwnerContractsMovementState> {
  final GetOwnerContractsMovementReportUseCase _getReportUseCase;
  
  int _currentPage = 1;
  bool _hasReachedMax = false;

  OwnerContractsMovementCubit(this._getReportUseCase)
      : super(OwnerContractsMovementInitial());

  Future<void> loadReport({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      emit(const OwnerContractsMovementLoading(isPagination: false));
    } else {
      if (state is OwnerContractsMovementLoading || _hasReachedMax) return;
      if (state is OwnerContractsMovementLoaded) {
        emit(OwnerContractsMovementLoading(isPagination: true));
      } else {
        emit(const OwnerContractsMovementLoading(isPagination: false));
      }
    }

    final result = await _getReportUseCase(
      forceRefresh: refresh,
      page: _currentPage,
    );

    result.fold(
      (failure) {
        if (state is OwnerContractsMovementLoaded && !refresh) {
          emit(OwnerContractsMovementError(failure.message));
        } else {
          emit(OwnerContractsMovementError(failure.message));
        }
      },
      (report) {
        if (report.items.isEmpty && refresh) {
          emit(OwnerContractsMovementEmpty());
          return;
        }

        _hasReachedMax = _currentPage >= report.pagination.lastPage;
        
        if (!refresh && state is OwnerContractsMovementLoaded) {
          final currentState = state as OwnerContractsMovementLoaded;
          final newItems = List.of(currentState.report.items)..addAll(report.items);
          final updatedReport = report.copyWith(items: newItems);
          emit(OwnerContractsMovementLoaded(
            report: updatedReport,
            hasReachedMax: _hasReachedMax,
          ));
        } else {
          emit(OwnerContractsMovementLoaded(
            report: report,
            hasReachedMax: _hasReachedMax,
          ));
        }
        
        if (!_hasReachedMax) {
          _currentPage++;
        }
      },
    );
  }
}
