import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_defaulters_report_use_case.dart';
import 'owner_defaulters_state.dart';

class OwnerDefaultersCubit extends Cubit<OwnerDefaultersState> {
  final GetOwnerDefaultersReportUseCase getOwnerDefaultersReportUseCase;

  OwnerDefaultersCubit(this.getOwnerDefaultersReportUseCase)
    : super(OwnerDefaultersInitial());

  int _currentPage = 1;
  bool _isFetching = false;
  int? selectedPropertyId;
  String? selectedStartDate;
  String? selectedEndDate;

  bool get hasActiveFilters =>
      selectedPropertyId != null ||
      selectedStartDate != null ||
      selectedEndDate != null;

  Future<void> loadDefaultersReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    if (propertyId != null) selectedPropertyId = propertyId == -1 ? null : propertyId;
    if (startDate != null) selectedStartDate = startDate.isEmpty ? null : startDate;
    if (endDate != null) selectedEndDate = endDate.isEmpty ? null : endDate;

    if (_isFetching) return;

    if (forceRefresh) {
      _currentPage = 1;
      emit(OwnerDefaultersLoading());
    } else {
      if (state is OwnerDefaultersLoaded) {
        if ((state as OwnerDefaultersLoaded).hasReachedMax) return;
        _currentPage++;
      } else {
        emit(OwnerDefaultersLoading());
      }
    }

    _isFetching = true;

    final result = await getOwnerDefaultersReportUseCase(
      forceRefresh: forceRefresh,
      page: _currentPage,
      propertyId: selectedPropertyId,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        if (_currentPage == 1) {
          emit(OwnerDefaultersError(failure.message));
        } else {
          _currentPage--;
        }
      },
      (report) {
        if (isClosed) return;
        if (report.items.isEmpty && _currentPage == 1) {
          emit(OwnerDefaultersEmpty());
        } else {
          final hasReachedMax =
              report.pagination.currentPage >= report.pagination.lastPage;

          if (_currentPage == 1) {
            emit(
              OwnerDefaultersLoaded(
                report: report,
                hasReachedMax: hasReachedMax,
              ),
            );
          } else {
            final currentState = state as OwnerDefaultersLoaded;
            emit(
              currentState.copyWith(
                report: currentState.report.copyWith(
                  items: List.of(currentState.report.items)
                    ..addAll(report.items),
                  pagination: report.pagination,
                ),
                hasReachedMax: hasReachedMax,
              ),
            );
          }
        }
      },
    );
  }

  void clearFilters() {
    selectedPropertyId = null;
    selectedStartDate = null;
    selectedEndDate = null;
    loadDefaultersReport(forceRefresh: true);
  }
}
