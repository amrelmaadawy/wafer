import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/error/failure_extensions.dart';
import '../../../../../../core/utils/app_page_status.dart';
import '../../../../../../core/utils/app_page_state_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/tasks_filter_params.dart';
import '../../../domain/usecases/get_tasks_usecase.dart';

part 'tasks_list_state.dart';

class TasksListCubit extends Cubit<TasksListState> {
  final GetTasksUseCase _getTasksUseCase;

  TasksListCubit(this._getTasksUseCase) : super(const TasksListState());

  bool _isFetching = false;

  Future<void> fetchTasks({bool refresh = false, bool isLoadMore = false}) async {
    if (_isFetching) return;
    if (isLoadMore && (state.hasReachedMax || state.isLoadingNextPage)) return;

    _isFetching = true;

    if (refresh) {
      emit(state.copyWith(
        status: state.items.isEmpty ? AppPageStatus.loading : AppPageStatus.refreshing,
        filterParams: state.filterParams.copyWith(page: 1),
        hasReachedMax: false,
        isLoadingNextPage: false,
      ));
    } else if (isLoadMore) {
      emit(state.copyWith(isLoadingNextPage: true));
    } else if (state.status == AppPageStatus.initial) {
      emit(state.copyWith(status: AppPageStatus.loading));
    }

    try {
      final currentParams = refresh
          ? state.filterParams.copyWith(page: 1)
          : state.filterParams;

      final result = await _getTasksUseCase(params: currentParams);

      result.fold(
        (failure) {
          emit(state.copyWith(
            status: isLoadMore ? state.status : failure.toPageStatus(),
            isLoadingNextPage: false,
            errorMessage: _mapFailureToMessage(failure),
          ));
        },
        (data) {
          final newTasks = List<TaskEntity>.from(data.$1);
          final meta = data.$2;
          final hasReachedMax = !meta.hasMore;
          final updatedItems = refresh || currentParams.page == 1
              ? newTasks
              : [...state.items, ...newTasks];

          emit(state.copyWith(
            status: updatedItems.isEmpty ? AppPageStatus.empty : AppPageStatus.success,
            items: updatedItems,
            filterParams: currentParams.copyWith(page: currentParams.page + 1),
            isLoadingNextPage: false,
            hasReachedMax: hasReachedMax,
          ));
        },
      );
    } finally {
      _isFetching = false;
    }
  }

  void search(String query) {
    if (state.filterParams.search == query) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        search: query.isEmpty ? null : query,
        clearSearch: query.isEmpty,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  void filterByStatus(String? status) {
    if (state.filterParams.status == status) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        status: status,
        clearStatus: status == null,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  void filterByPriority(String? priority) {
    if (state.filterParams.priority == priority) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        priority: priority,
        clearPriority: priority == null,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  void filterByAssignee(int? assigneeId) {
    if (state.filterParams.assigneeId == assigneeId) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        assigneeId: assigneeId,
        clearAssignee: assigneeId == null,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  void filterByDueDate(String? dueDate) {
    if (state.filterParams.dueDate == dueDate) return;
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        dueDate: dueDate,
        clearDueDate: dueDate == null,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  void applyAdvancedFilter(TasksFilterParams params) {
    emit(state.copyWith(
      filterParams: params.copyWith(page: 1),
    ));
    fetchTasks(refresh: true);
  }

  void setSort(String? sortBy, String? sortOrder) {
    emit(state.copyWith(
      filterParams: state.filterParams.copyWith(
        sortBy: sortBy,
        sortOrder: sortOrder,
        clearSort: sortBy == null,
        page: 1,
      ),
    ));
    fetchTasks(refresh: true);
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return LocaleKeys.errorOccurred.tr();
  }
}
