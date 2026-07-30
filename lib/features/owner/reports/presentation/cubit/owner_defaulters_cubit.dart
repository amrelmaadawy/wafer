import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_defaulters_report_use_case.dart';
import 'owner_defaulters_state.dart';

class OwnerDefaultersCubit extends Cubit<OwnerDefaultersState> {
  final GetOwnerDefaultersReportUseCase getOwnerDefaultersReportUseCase;

  OwnerDefaultersCubit(this.getOwnerDefaultersReportUseCase)
    : super(OwnerDefaultersInitial());

  int _currentPage = 1;
  bool _isFetching = false;

  Future<void> loadDefaultersReport({bool forceRefresh = false}) async {
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
    );

    result.fold(
      (failure) {
        if (_currentPage == 1) {
          emit(OwnerDefaultersError(failure.message));
        } else {
          _currentPage--;
          // Do not emit error for pagination to keep current items, could show a toast
        }
      },
      (report) {
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

    _isFetching = false;
  }
}
