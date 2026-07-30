import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_employee_tasks_report_use_case.dart';
import '../../domain/entities/employee_tasks_report_entity.dart';
import 'owner_employee_tasks_state.dart';

class OwnerEmployeeTasksCubit extends Cubit<OwnerEmployeeTasksState> {
  final GetOwnerEmployeeTasksReportUseCase _getEmployeeTasksReportUseCase;

  OwnerEmployeeTasksCubit(this._getEmployeeTasksReportUseCase)
    : super(OwnerEmployeeTasksInitial());

  int _currentPage = 1;
  bool _hasReachedMax = false;
  EmployeeTasksReportEntity? _currentReport;

  Future<void> fetchReport({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _currentReport = null;
      emit(const OwnerEmployeeTasksLoading(isPagination: false));
    } else if (_currentReport == null) {
      emit(const OwnerEmployeeTasksLoading(isPagination: false));
    } else {
      if (_hasReachedMax) return;
      emit(const OwnerEmployeeTasksLoading(isPagination: true));
    }

    final result = await _getEmployeeTasksReportUseCase(
      forceRefresh: forceRefresh,
      page: _currentPage,
    );

    result.fold(
      (failure) {
        if (_currentReport == null) {
          emit(OwnerEmployeeTasksError(failure.message));
        } else {
          emit(
            OwnerEmployeeTasksLoaded(
              report: _currentReport!,
              hasReachedMax: _hasReachedMax,
            ),
          );
        }
      },
      (report) {
        _hasReachedMax =
            report.pagination.currentPage >= report.pagination.lastPage;

        if (_currentReport == null || forceRefresh) {
          _currentReport = report;
        } else {
          _currentReport = EmployeeTasksReportEntity(
            summary: report.summary,
            items: [..._currentReport!.items, ...report.items],
            pagination: report.pagination,
          );
        }

        _currentPage++;

        if (_currentReport!.items.isEmpty) {
          emit(OwnerEmployeeTasksEmpty());
        } else {
          emit(
            OwnerEmployeeTasksLoaded(
              report: _currentReport!,
              hasReachedMax: _hasReachedMax,
            ),
          );
        }
      },
    );
  }
}
