part of 'tasks_list_cubit.dart';

enum TasksListStatus { initial, loading, loaded, error, loadingMore }

class TasksListState extends Equatable {
  final TasksListStatus status;
  final List<TaskEntity> items;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  const TasksListState({
    this.status = TasksListStatus.initial,
    this.items = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });

  TasksListState copyWith({
    TasksListStatus? status,
    List<TaskEntity>? items,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return TasksListState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, hasReachedMax, page, errorMessage];
}
