import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object?> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final TaskEntity task;

  const TaskDetailsLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
