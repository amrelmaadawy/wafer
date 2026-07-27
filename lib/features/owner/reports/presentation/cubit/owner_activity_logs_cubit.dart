import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/activity_logs_report_entity.dart';
import '../../domain/usecases/get_owner_activity_logs_report_use_case.dart';
import 'owner_activity_logs_state.dart';

class OwnerActivityLogsCubit extends Cubit<OwnerActivityLogsState> {
  final GetOwnerActivityLogsReportUseCase _getOwnerActivityLogsReportUseCase;
  ActivityLogsReportEntity? _currentReport;
  
  String? _selectedType;
  String? _selectedAction;
  bool _isFetching = false;

  OwnerActivityLogsCubit(this._getOwnerActivityLogsReportUseCase)
      : super(OwnerActivityLogsInitial());

  void setFilter({String? type, String? action}) {
    _selectedType = type;
    _selectedAction = action;
    fetchReport(forceRefresh: true);
  }

  void fetchReport({bool forceRefresh = false}) async {
    if (_isFetching) return;

    if (forceRefresh) {
      _currentReport = null;
    }

    final isPagination = _currentReport != null;
    int nextPage = 1;

    if (isPagination) {
      if (_currentReport!.pagination.currentPage >= _currentReport!.pagination.lastPage) {
        return;
      }
      nextPage = _currentReport!.pagination.currentPage + 1;
    }

    _isFetching = true;
    emit(OwnerActivityLogsLoading(isPagination: isPagination));

    final result = await _getOwnerActivityLogsReportUseCase(
      page: nextPage,
      type: _selectedType,
      action: _selectedAction,
    );

    result.fold(
      (failure) {
        _isFetching = false;
        if (isPagination && _currentReport != null) {
          emit(OwnerActivityLogsLoaded(_currentReport!));
        } else {
          // Determine error message if failure has a message field or fallback
          final errorMessage = failure is ServerFailure ? failure.message : 'حدث خطأ غير متوقع';
          emit(OwnerActivityLogsError(errorMessage));
        }
      },
      (report) {
        _isFetching = false;
        if (isPagination) {
          final updatedItems = List.of(_currentReport!.items)..addAll(report.items);
          _currentReport = ActivityLogsReportEntity(
            summary: report.summary,
            items: updatedItems,
            pagination: report.pagination,
            types: report.types,
            actions: report.actions,
          );
        } else {
          _currentReport = report;
        }

        if (_currentReport!.items.isEmpty) {
          emit(OwnerActivityLogsEmpty());
        } else {
          emit(OwnerActivityLogsLoaded(_currentReport!));
        }
      },
    );
  }
}
