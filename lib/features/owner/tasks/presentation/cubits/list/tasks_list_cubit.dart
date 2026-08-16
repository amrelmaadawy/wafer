import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/get_tasks_usecase.dart';

part 'tasks_list_state.dart';

class TasksListCubit extends Cubit<TasksListState> {
  final GetTasksUseCase _getTasksUseCase;

  TasksListCubit(this._getTasksUseCase) : super(const TasksListState());

  bool _isFetching = false;

  Future<void> fetchTasks({bool refresh = false}) async {
    if (_isFetching && !refresh) return;
    if (state.hasReachedMax && !refresh) return;

    _isFetching = true;

    if (refresh) {
      emit(state.copyWith(status: TasksListStatus.loading, items: [], page: 1, hasReachedMax: false));
    } else if (state.status == TasksListStatus.initial) {
      emit(state.copyWith(status: TasksListStatus.loading));
    } else {
      emit(state.copyWith(status: TasksListStatus.loadingMore));
    }

    try {
      final result = await _getTasksUseCase(page: state.page, perPage: 15);

      result.fold(
      (failure) {
        emit(state.copyWith(
          status: TasksListStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (data) {
        final newTasks = List<TaskEntity>.from(data.$1);
        final meta = data.$2;
        final hasReachedMax = !meta.hasMore;

        emit(state.copyWith(
          status: TasksListStatus.loaded,
          items: refresh ? newTasks : [...state.items, ...newTasks],
          page: state.page + 1,
          hasReachedMax: hasReachedMax,
        ));
      },
    );
    } finally {
      _isFetching = false;
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return LocaleKeys.errorOccurred.tr();
  }
}



