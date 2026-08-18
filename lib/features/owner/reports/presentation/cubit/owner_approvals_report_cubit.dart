import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_approvals_report_use_case.dart';
import '../../domain/entities/approvals_report_entity.dart';
import 'owner_approvals_report_state.dart';

class OwnerApprovalsReportCubit extends Cubit<OwnerApprovalsReportState> {
  final GetApprovalsReportUseCase getApprovalsReportUseCase;
  int _currentPage = 1;
  bool _isFetching = false;
  ApprovalsReportEntity? _currentReport;
  String? selectedStatus;
  String? selectedStartDate;
  String? selectedEndDate;

  bool get hasActiveFilters =>
      selectedStatus != null ||
      selectedStartDate != null ||
      selectedEndDate != null;

  OwnerApprovalsReportCubit({required this.getApprovalsReportUseCase})
    : super(OwnerApprovalsReportInitial());

  Future<void> fetchReport({
    bool isRefresh = false,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (status != null) selectedStatus = status == 'ALL' ? null : status;
    if (startDate != null) selectedStartDate = startDate.isEmpty ? null : startDate;
    if (endDate != null) selectedEndDate = endDate.isEmpty ? null : endDate;

    if (_isFetching) return;

    if (isRefresh) {
      _currentPage = 1;
      _currentReport = null;
    }

    if (_currentReport != null &&
        _currentPage > _currentReport!.pagination.lastPage) {
      return; // Reached max
    }

    _isFetching = true;

    emit(
      OwnerApprovalsReportLoading(
        isFirstFetch: _currentReport == null,
        report: _currentReport,
      ),
    );

    final result = await getApprovalsReportUseCase(
      forceRefresh: isRefresh,
      page: _currentPage,
      status: selectedStatus,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    );

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(OwnerApprovalsReportError(message: failure.message));
        }
      },
      (report) {
        if (isClosed) return;

        if (report.items.isEmpty && _currentPage == 1) {
          emit(OwnerApprovalsReportEmpty());
        } else {
          _currentPage++;

          if (_currentReport != null) {
            final allItems = List<ApprovalItemEntity>.from(
              _currentReport!.items,
            )..addAll(report.items);
            _currentReport = ApprovalsReportEntity(
              summary: report.summary,
              items: allItems,
              pagination: report.pagination,
              filterOptions: report.filterOptions,
            );
          } else {
            _currentReport = report;
          }

          final hasReachedMax = _currentPage > report.pagination.lastPage;

          emit(
            OwnerApprovalsReportLoaded(
              report: _currentReport!,
              hasReachedMax: hasReachedMax,
            ),
          );
        }
      },
    );

    _isFetching = false;
  }

  void clearFilters() {
    selectedStatus = null;
    selectedStartDate = null;
    selectedEndDate = null;
    fetchReport(isRefresh: true);
  }
}
