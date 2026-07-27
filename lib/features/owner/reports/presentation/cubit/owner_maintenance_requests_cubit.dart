import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/maintenance_requests_report_entity.dart';
import '../../domain/usecases/get_owner_maintenance_requests_report_use_case.dart';
import 'owner_maintenance_requests_state.dart';

class OwnerMaintenanceRequestsCubit extends Cubit<OwnerMaintenanceRequestsState> {
  final GetOwnerMaintenanceRequestsReportUseCase _getMaintenanceRequestsReportUseCase;
  
  MaintenanceRequestsReportEntity? _currentReport;
  int _currentPage = 1;
  bool _isFetching = false;

  OwnerMaintenanceRequestsCubit(this._getMaintenanceRequestsReportUseCase)
      : super(OwnerMaintenanceRequestsInitial());

  Future<void> loadReport({bool refresh = false}) async {
    if (_isFetching) return;
    
    if (refresh) {
      _currentPage = 1;
      _currentReport = null;
      emit(const OwnerMaintenanceRequestsLoading());
    } else {
      if (_currentReport != null && _currentPage >= _currentReport!.pagination.lastPage) {
        return; 
      }
      if (_currentReport != null) {
        _currentPage++;
        emit(const OwnerMaintenanceRequestsLoading(isPagination: true));
      } else {
        emit(const OwnerMaintenanceRequestsLoading());
      }
    }

    _isFetching = true;

    final result = await _getMaintenanceRequestsReportUseCase(
      page: _currentPage,
      forceRefresh: refresh,
    );

    result.fold(
      (failure) {
        if (_currentPage > 1) _currentPage--;
        emit(OwnerMaintenanceRequestsError(failure.message));
      },
      (report) {
        if (report.items.isEmpty && _currentReport == null) {
          emit(OwnerMaintenanceRequestsEmpty());
        } else {
          if (_currentReport != null && !refresh) {
            final updatedItems = List.of(_currentReport!.items)..addAll(report.items);
            _currentReport = MaintenanceRequestsReportEntity(
              summary: report.summary,
              items: updatedItems,
              pagination: report.pagination,
            );
          } else {
            _currentReport = report;
          }
          
          final hasReachedMax = _currentPage >= _currentReport!.pagination.lastPage;
          emit(OwnerMaintenanceRequestsLoaded(_currentReport!, hasReachedMax: hasReachedMax));
        }
      },
    );
    
    _isFetching = false;
  }
}
