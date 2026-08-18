import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_legal_cases_report_use_case.dart';
import 'owner_legal_cases_report_state.dart';

class OwnerLegalCasesReportCubit extends Cubit<OwnerLegalCasesReportState> {
  final GetLegalCasesReportUseCase getLegalCasesReportUseCase;

  OwnerLegalCasesReportCubit({required this.getLegalCasesReportUseCase})
    : super(OwnerLegalCasesReportInitial());

  int _currentPage = 1;
  bool _isFetching = false;
  String? _selectedStatus;
  String? _selectedStartDate;
  String? _selectedEndDate;

  String? get selectedStatus => _selectedStatus;
  String? get selectedStartDate => _selectedStartDate;
  String? get selectedEndDate => _selectedEndDate;

  bool get hasActiveFilters =>
      _selectedStatus != null ||
      _selectedStartDate != null ||
      _selectedEndDate != null;

  Future<void> fetchReport({
    bool isRefresh = false,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (_isFetching) return;

    if (status != null) {
      _selectedStatus = status == 'ALL' ? null : status;
      isRefresh = true;
    }
    if (startDate != null) {
      _selectedStartDate = startDate.isEmpty ? null : startDate;
      isRefresh = true;
    }
    if (endDate != null) {
      _selectedEndDate = endDate.isEmpty ? null : endDate;
      isRefresh = true;
    }

    if (isRefresh) {
      _currentPage = 1;
    }

    final isFirstFetch = _currentPage == 1;

    _isFetching = true;

    if (isFirstFetch) {
      emit(const OwnerLegalCasesReportLoading(isFirstFetch: true));
    } else {
      emit(const OwnerLegalCasesReportLoading(isFirstFetch: false));
    }

    final result = await getLegalCasesReportUseCase(
      GetLegalCasesReportParams(
        forceRefresh: isRefresh,
        page: _currentPage,
        status: _selectedStatus,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
      ),
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(OwnerLegalCasesReportError(failure.message));
      },
      (report) {
        if (isClosed) return;
        if (isFirstFetch && report.items.isEmpty) {
          emit(OwnerLegalCasesReportEmpty());
        } else {
          emit(OwnerLegalCasesReportLoaded(report));
          _currentPage++;
        }
      },
    );
  }

  void clearFilters() {
    _selectedStatus = null;
    _selectedStartDate = null;
    _selectedEndDate = null;
    fetchReport(isRefresh: true);
  }
}
