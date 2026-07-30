import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_occupancy_report_use_case.dart';
import '../../domain/entities/occupancy_report_entity.dart';
import 'owner_occupancy_state.dart';

class OwnerOccupancyCubit extends Cubit<OwnerOccupancyState> {
  final GetOwnerOccupancyReportUseCase _getOwnerOccupancyReportUseCase;

  OwnerOccupancyCubit(this._getOwnerOccupancyReportUseCase)
    : super(const OwnerOccupancyInitial());

  int _currentPage = 1;
  bool _isFetching = false;

  Future<void> loadOccupancyReport({bool forceRefresh = false}) async {
    if (_isFetching) return;

    if (forceRefresh) {
      _currentPage = 1;
      emit(const OwnerOccupancyLoading());
    } else if (state is OwnerOccupancyLoaded) {
      final currentState = state as OwnerOccupancyLoaded;
      if (currentState.hasReachedMax) return;
    } else {
      emit(const OwnerOccupancyLoading());
    }

    _isFetching = true;

    final result = await _getOwnerOccupancyReportUseCase(
      forceRefresh: forceRefresh,
      page: _currentPage,
    );

    result.fold(
      (failure) {
        if (state is! OwnerOccupancyLoaded) {
          emit(OwnerOccupancyError(failure.message));
        }
      },
      (report) {
        if (report.items.isEmpty && _currentPage == 1) {
          emit(const OwnerOccupancyEmpty());
        } else {
          if (state is OwnerOccupancyLoaded && !forceRefresh) {
            final currentState = state as OwnerOccupancyLoaded;
            final updatedItems = List.of(currentState.report.items)
              ..addAll(report.items);

            final updatedReport = OccupancyReportEntity(
              summary: report.summary,
              pagination: report.pagination,
              items: updatedItems,
            );

            emit(
              OwnerOccupancyLoaded(
                report: updatedReport,
                hasReachedMax:
                    report.pagination.currentPage >= report.pagination.lastPage,
              ),
            );
          } else {
            emit(
              OwnerOccupancyLoaded(
                report: report,
                hasReachedMax:
                    report.pagination.currentPage >= report.pagination.lastPage,
              ),
            );
          }
          if (report.pagination.currentPage < report.pagination.lastPage) {
            _currentPage++;
          }
        }
      },
    );

    _isFetching = false;
  }
}
