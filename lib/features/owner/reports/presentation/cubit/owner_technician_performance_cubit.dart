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
  String? selectedStartDate;
  String? selectedEndDate;

  bool get hasActiveFilters =>
      selectedStartDate != null || selectedEndDate != null;

  OwnerTechnicianPerformanceCubit(this._getTechnicianPerformanceReportUseCase)
    : super(OwnerTechnicianPerformanceInitial());

  Future<void> loadReport({
    bool refresh = false,
    String? startDate,
    String? endDate,
  }) async {
    if (startDate != null) selectedStartDate = startDate.isEmpty ? null : startDate;
    if (endDate != null) selectedEndDate = endDate.isEmpty ? null : endDate;

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
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        if (_currentPage > 1) _currentPage--;
        emit(OwnerTechnicianPerformanceError(failure.message));
      },
      (report) {
        if (isClosed) return;
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
  }

  void clearFilters() {
    selectedStartDate = null;
    selectedEndDate = null;
    loadReport(refresh: true);
  }
}
