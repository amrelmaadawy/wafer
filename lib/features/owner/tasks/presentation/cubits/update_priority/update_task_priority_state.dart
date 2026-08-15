import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class UpdateTaskPriorityState extends Equatable {
  const UpdateTaskPriorityState();

  @override
  List<Object> get props => [];
}

class UpdateTaskPriorityInitial extends UpdateTaskPriorityState {}

class UpdateTaskPriorityLoading extends UpdateTaskPriorityState {}

class UpdateTaskPrioritySuccess extends UpdateTaskPriorityState {
  final TaskEntity task;

  const UpdateTaskPrioritySuccess({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskPriorityError extends UpdateTaskPriorityState {
  final String message;

  const UpdateTaskPriorityError({required this.message});

  @override
  List<Object> get props => [message];
}
