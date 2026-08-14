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

  Future<void> fetchReport({bool isRefresh = false, String? status}) async {
    if (_isFetching) return;

    if (status != null && status != _selectedStatus) {
      _selectedStatus = status;
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
      GetLegalCasesReportParams(page: _currentPage, status: _selectedStatus),
    );

    result.fold(
      (failure) {
        emit(OwnerLegalCasesReportError(failure.message));
        _isFetching = false;
      },
      (report) {
        if (isFirstFetch && report.items.isEmpty) {
          emit(OwnerLegalCasesReportEmpty());
        } else {
          emit(OwnerLegalCasesReportLoaded(report));
          _currentPage++;
        }
        _isFetching = false;
      },
    );
  }
}
