import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/supervisor_entity.dart';
import '../../../domain/usecases/get_supervisors_use_case.dart';
import 'supervisors_list_state.dart';

class SupervisorsListCubit extends Cubit<SupervisorsListState> {
  final GetSupervisorsUseCase getSupervisorsUseCase;
  int _currentPage = 1;
  bool _isFetching = false;

  SupervisorsListCubit({required this.getSupervisorsUseCase})
    : super(const SupervisorsListState());

  Future<void> fetchSupervisors({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (isRefresh) {
        _currentPage = 1;
        emit(
          state.copyWith(
            status: SupervisorsListStatus.loading,
            hasReachedMax: false,
            errorMessage: null,
          ),
        );
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
            emit(
              state.copyWith(
                status: SupervisorsListStatus.failure,
                errorMessage: failure.message,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: SupervisorsListStatus.success,
                errorMessage: failure.message,
              ),
            );
          }
        },
        (response) {
          final newSupervisors = isRefresh
              ? response.supervisors
              : _deduplicate([...state.supervisors, ...response.supervisors]);
          final hasReachedMax =
              response.pagination.currentPage >= response.pagination.lastPage;

          if (!hasReachedMax) {
            _currentPage++;
          }

          emit(
            state.copyWith(
              status: SupervisorsListStatus.success,
              supervisors: newSupervisors,
              pagination: response.pagination,
              hasReachedMax: hasReachedMax,
              errorMessage: null,
            ),
          );
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  void addSupervisor(SupervisorEntity supervisor) {
    if (state.status == SupervisorsListStatus.success) {
      final updatedList = _deduplicate([supervisor, ...state.supervisors]);
      emit(state.copyWith(supervisors: updatedList));
    }
  }

  List<SupervisorEntity> _deduplicate(List<SupervisorEntity> supervisors) {
    final seen = <int>{};
    return supervisors.where((s) => seen.add(s.id)).toList();
  }
}
