import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/technician_performance_report_entity.dart';
import '../../domain/usecases/get_owner_technician_performance_report_use_case.dart';
import 'owner_technician_performance_state.dart';

class OwnerTechnicianPerformanceCubit
    extends Cubit<OwnerTechnicianPerformanceState> {
  final GetOwnerTechnicianPerformanceReportUseCase
  _getTechnicianPerformanceReportUseCase;

  TechnicianPerformanceReportEntity? _currentReport;
  int _currentPage = 1;
  bool _isFetching = false;

  OwnerTechnicianPerformanceCubit(this._getTechnicianPerformanceReportUseCase)
    : super(OwnerTechnicianPerformanceInitial());

  Future<void> loadReport({bool refresh = false}) async {
    if (_isFetching) return;

    if (refresh) {
      _currentPage = 1;
      _currentReport = null;
      emit(const OwnerTechnicianPerformanceLoading());
    } else {
      if (_currentReport != null &&
          _currentPage >= _currentReport!.pagination.lastPage) {
        return;
      }
      if (_currentReport != null) {
        _currentPage++;
        emit(const OwnerTechnicianPerformanceLoading(isPagination: true));
      } else {
        emit(const OwnerTechnicianPerformanceLoading());
      }
    }

    _isFetching = true;

    final result = await _getTechnicianPerformanceReportUseCase(
      page: _currentPage,
      forceRefresh: refresh,
    );

    result.fold(
      (failure) {
        if (_currentPage > 1) _currentPage--;
        emit(OwnerTechnicianPerformanceError(failure.message));
      },
      (report) {
        if (report.items.isEmpty && _currentReport == null) {
          emit(OwnerTechnicianPerformanceEmpty());
        } else {
          if (_currentReport != null && !refresh) {
            final updatedItems = List.of(_currentReport!.items)
              ..addAll(report.items);
            _currentReport = TechnicianPerformanceReportEntity(
              summary: report.summary,
              items: updatedItems,
              pagination: report.pagination,
            );
          } else {
            _currentReport = report;
          }

          final hasReachedMax =
              _currentPage >= _currentReport!.pagination.lastPage;
          emit(
            OwnerTechnicianPerformanceLoaded(
              _currentReport!,
              hasReachedMax: hasReachedMax,
            ),
          );
        }
      },
    );

    _isFetching = false;
  }
}
