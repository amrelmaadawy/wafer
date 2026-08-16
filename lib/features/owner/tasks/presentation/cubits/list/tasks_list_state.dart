part of 'tasks_list_cubit.dart';

class TasksListState extends Equatable with AppPageStateMixin {
  @override
  final AppPageStatus status;
  final List<TaskEntity> items;
  final TasksFilterParams filterParams;
  final bool isLoadingNextPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const TasksListState({
    this.status = AppPageStatus.initial,
    this.items = const [],
    this.filterParams = const TasksFilterParams(),
    this.isLoadingNextPage = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  TasksListState copyWith({
    AppPageStatus? status,
    List<TaskEntity>? items,
    TasksFilterParams? filterParams,
    bool? isLoadingNextPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return TasksListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filterParams: filterParams ?? this.filterParams,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        filterParams,
        isLoadingNextPage,
        hasReachedMax,
        errorMessage,
      ];
}
