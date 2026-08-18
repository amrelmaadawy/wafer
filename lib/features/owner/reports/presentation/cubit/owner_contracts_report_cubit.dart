import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_contracts_report_use_case.dart';
import 'owner_contracts_report_state.dart';

class OwnerContractsReportCubit extends Cubit<OwnerContractsReportState> {
  final GetContractsReportUseCase getContractsReportUseCase;
  int _currentPage = 1;
  int? _selectedPropertyId;
  String? _selectedStatus;
  String? _selectedStartDate;
  String? _selectedEndDate;
  bool _isFetching = false;

  int? get selectedPropertyId => _selectedPropertyId;
  String? get selectedStatus => _selectedStatus;
  String? get selectedStartDate => _selectedStartDate;
  String? get selectedEndDate => _selectedEndDate;
  bool get hasActiveFilters =>
      _selectedPropertyId != null ||
      _selectedStatus != null ||
      (_selectedStartDate != null && _selectedEndDate != null);

  OwnerContractsReportCubit({required this.getContractsReportUseCase})
      : super(OwnerContractsReportInitial());

  void clearFilters() {
    _selectedPropertyId = null;
    _selectedStatus = null;
    _selectedStartDate = null;
    _selectedEndDate = null;
    loadContractsReport(forceRefresh: true);
  }

  Future<void> loadContractsReport({
    bool forceRefresh = false,
    int? propertyId,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (_isFetching) return;

    if (forceRefresh ||
        propertyId != _selectedPropertyId ||
        status != _selectedStatus ||
        startDate != _selectedStartDate ||
        endDate != _selectedEndDate) {
      _currentPage = 1;
      _selectedPropertyId = propertyId ?? _selectedPropertyId;
      _selectedStatus = status ?? _selectedStatus;
      _selectedStartDate = startDate ?? _selectedStartDate;
      _selectedEndDate = endDate ?? _selectedEndDate;
      emit(OwnerContractsReportLoading());
    } else {
      if (state is OwnerContractsReportLoaded &&
          (state as OwnerContractsReportLoaded).hasReachedMax) {
        return;
      }
    }

    _isFetching = true;

    final result = await getContractsReportUseCase(
      forceRefresh: forceRefresh,
      page: _currentPage,
      propertyId: _selectedPropertyId,
      status: _selectedStatus,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        if (_currentPage == 1) {
          emit(OwnerContractsReportError(failure.message));
        } else {
          final currentState = state;
          if (currentState is OwnerContractsReportLoaded) {
            emit(
              OwnerContractsReportLoaded(
                report: currentState.report,
                hasReachedMax: true,
              ),
            );
          }
        }
      },
      (report) {
        if (isClosed) return;
        if (_currentPage == 1) {
          emit(
            OwnerContractsReportLoaded(
              report: report,
              hasReachedMax:
                  report.pagination.currentPage >= report.pagination.lastPage,
            ),
          );
        } else {
          final currentState = state;
          if (currentState is OwnerContractsReportLoaded) {
            final newItems = List.of(currentState.report.items)
              ..addAll(report.items);
            final newReport = currentState.report.copyWith(
              items: newItems,
              pagination: report.pagination,
            );

            emit(
              OwnerContractsReportLoaded(
                report: newReport,
                hasReachedMax:
                    report.pagination.currentPage >= report.pagination.lastPage,
              ),
            );
          }
        }
        _currentPage++;
      },
    );
  }
}
