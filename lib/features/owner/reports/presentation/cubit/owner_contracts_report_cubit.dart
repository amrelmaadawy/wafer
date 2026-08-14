import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_contracts_report_use_case.dart';
import 'owner_contracts_report_state.dart';

class OwnerContractsReportCubit extends Cubit<OwnerContractsReportState> {
  final GetContractsReportUseCase getContractsReportUseCase;
  int _currentPage = 1;
  int? _selectedPropertyId;
  String? _selectedStatus;
  bool _isFetching = false;

  OwnerContractsReportCubit({required this.getContractsReportUseCase})
    : super(OwnerContractsReportInitial());

  Future<void> loadContractsReport({
    bool forceRefresh = false,
    int? propertyId,
    String? status,
  }) async {
    if (_isFetching) return;

    if (forceRefresh ||
        propertyId != _selectedPropertyId ||
        status != _selectedStatus) {
      _currentPage = 1;
      _selectedPropertyId = propertyId ?? _selectedPropertyId;
      _selectedStatus = status ?? _selectedStatus;
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
    );

    result.fold(
      (failure) {
        if (_currentPage == 1) {
          emit(OwnerContractsReportError(failure.message));
        } else {
          // If pagination fails, we just keep the loaded state
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

    _isFetching = false;
  }
}
