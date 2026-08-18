import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/activity_logs_report_entity.dart';
import '../../domain/usecases/get_owner_activity_logs_report_use_case.dart';
import 'owner_activity_logs_state.dart';

class OwnerActivityLogsCubit extends Cubit<OwnerActivityLogsState> {
  final GetOwnerActivityLogsReportUseCase _getOwnerActivityLogsReportUseCase;
  ActivityLogsReportEntity? _currentReport;

  String? selectedType;
  String? selectedAction;
  String? selectedStartDate;
  String? selectedEndDate;
  bool _isFetching = false;

  OwnerActivityLogsCubit(this._getOwnerActivityLogsReportUseCase)
    : super(OwnerActivityLogsInitial());

  bool get hasActiveFilters =>
      selectedType != null ||
      selectedAction != null ||
      selectedStartDate != null ||
      selectedEndDate != null;

  Future<void> setFilters({
    String? type,
    String? action,
    String? startDate,
    String? endDate,
  }) {
    if (type != null) selectedType = type == '__all__' ? null : type;
    if (action != null) selectedAction = action == '__all__' ? null : action;
    if (startDate != null) selectedStartDate = startDate.isEmpty ? null : startDate;
    if (endDate != null) selectedEndDate = endDate.isEmpty ? null : endDate;
    return fetchReport(forceRefresh: true);
  }

  Future<void> clearFilters() {
    selectedType = null;
    selectedAction = null;
    selectedStartDate = null;
    selectedEndDate = null;
    return fetchReport(forceRefresh: true);
  }

  Future<void> fetchReport({bool forceRefresh = false}) async {
    if (_isFetching) return;

    if (forceRefresh) {
      _currentReport = null;
    }

    final isPagination = _currentReport != null;
    int nextPage = 1;

    if (isPagination) {
      if (_currentReport!.pagination.currentPage >=
          _currentReport!.pagination.lastPage) {
        return;
      }
      nextPage = _currentReport!.pagination.currentPage + 1;
    }

    _isFetching = true;
    emit(
      OwnerActivityLogsLoading(
        isPagination: isPagination,
        report: _currentReport,
      ),
    );

    final result = await _getOwnerActivityLogsReportUseCase(
      forceRefresh: forceRefresh,
      page: nextPage,
      type: selectedType,
      action: selectedAction,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    );

    result.fold(
      (failure) {
        _isFetching = false;
        if (isClosed) return;
        if (isPagination && _currentReport != null) {
          emit(OwnerActivityLogsLoaded(_currentReport!));
        } else {
          emit(OwnerActivityLogsError(failure.message));
        }
      },
      (report) {
        _isFetching = false;
        if (isClosed) return;
        if (isPagination) {
          final updatedItems = List.of(_currentReport!.items)
            ..addAll(report.items);
          _currentReport = ActivityLogsReportEntity(
            summary: report.summary,
            items: updatedItems,
            pagination: report.pagination,
            types: report.types.isEmpty ? _currentReport!.types : report.types,
            actions: report.actions.isEmpty
                ? _currentReport!.actions
                : report.actions,
          );
        } else {
          _currentReport = report;
        }

        if (_currentReport!.items.isEmpty) {
          emit(OwnerActivityLogsEmpty(_currentReport!));
        } else {
          emit(OwnerActivityLogsLoaded(_currentReport!));
        }
      },
    );
  }
}
