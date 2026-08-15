import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class RemoveTaskAssigneeState extends Equatable {
  const RemoveTaskAssigneeState();

  @override
  List<Object> get props => [];
}

class RemoveTaskAssigneeInitial extends RemoveTaskAssigneeState {}

class RemoveTaskAssigneeLoading extends RemoveTaskAssigneeState {
  final int assigneeId; // To identify which one is loading
  const RemoveTaskAssigneeLoading({required this.assigneeId});

  @override
  List<Object> get props => [assigneeId];
}

class RemoveTaskAssigneeSuccess extends RemoveTaskAssigneeState {
  final TaskEntity task;

  const RemoveTaskAssigneeSuccess({required this.task});

  @override
  List<Object> get props => [task];
}

class RemoveTaskAssigneeError extends RemoveTaskAssigneeState {
  final String message;

  const RemoveTaskAssigneeError({required this.message});

  @override
  List<Object> get props => [message];
}
