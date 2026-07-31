import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_supervisors_use_case.dart';
import 'supervisors_list_state.dart';

class SupervisorsListCubit extends Cubit<SupervisorsListState> {
  final GetSupervisorsUseCase getSupervisorsUseCase;
  int _currentPage = 1;

  SupervisorsListCubit({required this.getSupervisorsUseCase})
      : super(const SupervisorsListState());

  Future<void> fetchSupervisors({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      emit(state.copyWith(
        status: SupervisorsListStatus.loading,
        hasReachedMax: false,
      ));
    } else {
      if (state.hasReachedMax) return;
      if (state.status == SupervisorsListStatus.initial) {
        emit(state.copyWith(status: SupervisorsListStatus.loading));
      } else {
        emit(state.copyWith(status: SupervisorsListStatus.loadingMore));
      }
    }

    final result = await getSupervisorsUseCase(_currentPage);

    result.fold(
      (failure) {
        if (_currentPage == 1) {
          emit(state.copyWith(
            status: SupervisorsListStatus.failure,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(
            status: SupervisorsListStatus.success,
            errorMessage: failure.message,
          ));
        }
      },
      (response) {
        final newSupervisors = isRefresh
            ? response.supervisors
            : [...state.supervisors, ...response.supervisors];
        final hasReachedMax = response.pagination.currentPage >= response.pagination.lastPage;

        if (!hasReachedMax) {
          _currentPage++;
        }

        emit(state.copyWith(
          status: SupervisorsListStatus.success,
          supervisors: newSupervisors,
          pagination: response.pagination,
          hasReachedMax: hasReachedMax,
          errorMessage: null,
        ));
      },
    );
  }
}
