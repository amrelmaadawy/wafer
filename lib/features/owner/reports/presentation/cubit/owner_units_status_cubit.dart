import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_units_status_report_usecase.dart';
import '../../domain/entities/units_status_report_entity.dart';
import 'owner_units_status_state.dart';

class OwnerUnitsStatusCubit extends Cubit<OwnerUnitsStatusState> {
  final GetOwnerUnitsStatusReportUseCase _getReportUseCase;

  OwnerUnitsStatusCubit(this._getReportUseCase)
    : super(const OwnerUnitsStatusInitial());

  int? selectedPropertyId;
  String? selectedStatus;
  int _currentPage = 1;
  bool _isFetching = false;

  bool get hasActiveFilters =>
      selectedPropertyId != null || selectedStatus != null;

  Future<void> loadUnitsStatusReport({
    bool forceRefresh = false,
    int? propertyId,
    String? status,
  }) async {
    if (_isFetching) return;

    if (propertyId != null) {
      selectedPropertyId = propertyId == -1 ? null : propertyId;
    }
    if (status != null) {
      selectedStatus = status == 'ALL' ? null : status;
    }

    if (forceRefresh) {
      _currentPage = 1;
      emit(const OwnerUnitsStatusLoading());
    }

    _isFetching = true;

    final result = await _getReportUseCase(
      GetOwnerUnitsStatusReportParams(
        forceRefresh: forceRefresh,
        page: _currentPage,
        propertyId: selectedPropertyId,
        status: selectedStatus,
      ),
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (_currentPage > 1) _currentPage--;
        if (_currentPage == 1) {
          emit(OwnerUnitsStatusError(failure.message));
        }
      },
      (report) {
        if (_currentPage == 1) {
          if (report.items.isEmpty) {
            emit(OwnerUnitsStatusEmpty(filterOptions: report.filterOptions));
          } else {
            emit(
              OwnerUnitsStatusLoaded(
                report: report,
                hasReachedMax:
                    report.pagination.currentPage >= report.pagination.lastPage,
              ),
            );
          }
        } else if (state is OwnerUnitsStatusLoaded) {
          final currentState = state as OwnerUnitsStatusLoaded;
          final updatedItems = List.of(currentState.report.items)
            ..addAll(report.items);

          final updatedReport = UnitsStatusReportEntity(
            summary: report.summary,
            items: updatedItems,
            pagination: report.pagination,
            filterOptions: report.filterOptions,
          );

          emit(
            OwnerUnitsStatusLoaded(
              report: updatedReport,
              hasReachedMax:
                  report.pagination.currentPage >= report.pagination.lastPage,
            ),
          );
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (state is OwnerUnitsStatusLoaded) {
      final currentState = state as OwnerUnitsStatusLoaded;
      if (!currentState.hasReachedMax && !_isFetching) {
        _currentPage++;
        await loadUnitsStatusReport();
      }
    }
  }

  void clearFilters() {
    selectedPropertyId = null;
    selectedStatus = null;
    loadUnitsStatusReport(forceRefresh: true);
  }
}
