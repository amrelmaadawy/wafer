import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_revenue_report_use_case.dart';
import 'owner_revenue_state.dart';

class OwnerRevenueCubit extends Cubit<OwnerRevenueState> {
  final GetOwnerRevenueReportUseCase _getReportUseCase;

  OwnerRevenueCubit(this._getReportUseCase)
    : super(const OwnerRevenueInitial());

  int? selectedPropertyId;
  String? selectedStartDate;
  String? selectedEndDate;

  Future<void> loadRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    if (propertyId != null || propertyId == -1) {
      selectedPropertyId = propertyId == -1 ? null : propertyId;
    }
    if (startDate != null) {
      selectedStartDate = startDate == '' ? null : startDate;
    }
    if (endDate != null) {
      selectedEndDate = endDate == '' ? null : endDate;
    }

    if (state is! OwnerRevenueLoaded || forceRefresh) {
      emit(const OwnerRevenueLoading());
    }

    final result = await _getReportUseCase(
      GetOwnerRevenueReportParams(
        forceRefresh: forceRefresh,
        propertyId: selectedPropertyId,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      ),
    );

    if (isClosed) return;

    result.fold((failure) => emit(OwnerRevenueError(failure.message)), (
      report,
    ) {
      if (report.chart.isEmpty && report.summary.totalExpected == 0) {
        emit(const OwnerRevenueEmpty());
      } else {
        emit(OwnerRevenueLoaded(report: report));
      }
    });
  }

  void clearFilters() {
    selectedPropertyId = null;
    selectedStartDate = null;
    selectedEndDate = null;
    loadRevenueReport(forceRefresh: true);
  }
}
