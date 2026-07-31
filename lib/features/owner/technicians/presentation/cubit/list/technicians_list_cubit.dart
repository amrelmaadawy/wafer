import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/technicians/domain/usecases/get_technicians_list_use_case.dart';
import 'technicians_list_state.dart';

class TechniciansListCubit extends Cubit<TechniciansListState> {
  final GetTechniciansListUseCase getTechniciansListUseCase;
  int _currentPage = 1;
  Map<String, dynamic>? _currentFilters;

  TechniciansListCubit({
    required this.getTechniciansListUseCase,
  }) : super(const TechniciansListState());

  Future<void> loadTechnicians({
    bool forceRefresh = false,
    Map<String, dynamic>? filters,
  }) async {
    if (forceRefresh) {
      _currentPage = 1;
      _currentFilters = filters ?? _currentFilters;
      emit(state.copyWith(
        status: TechniciansListStatus.loading,
        hasReachedMax: false,
      ));
    } else {
      if (state.hasReachedMax) return;
      emit(state.copyWith(status: TechniciansListStatus.loadingMore));
    }

    final params = GetTechniciansListParams(
      page: _currentPage,
      filters: _currentFilters,
    );

    final result = await getTechniciansListUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: TechniciansListStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (response) {
        final newTechnicians = forceRefresh
            ? response.technicians
            : [...state.technicians, ...response.technicians];

        final hasReachedMax =
            response.pagination.currentPage >= response.pagination.lastPage;

        if (hasReachedMax == false) {
          _currentPage++;
        }

        emit(state.copyWith(
          status: TechniciansListStatus.success,
          technicians: newTechnicians,
          pagination: response.pagination,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
  }

  void updateFilters(Map<String, dynamic> filters) {
    loadTechnicians(forceRefresh: true, filters: filters);
  }
}
