import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class AddTaskAssigneeState extends Equatable {
  const AddTaskAssigneeState();

  @override
  List<Object> get props => [];
}

class AddTaskAssigneeInitial extends AddTaskAssigneeState {}

class AddTaskAssigneeLoading extends AddTaskAssigneeState {}

class AddTaskAssigneeSuccess extends AddTaskAssigneeState {
  final TaskEntity task;

  const AddTaskAssigneeSuccess({required this.task});

  @override
  List<Object> get props => [task];
}

class AddTaskAssigneeError extends AddTaskAssigneeState {
  final String message;

  const AddTaskAssigneeError({required this.message});

  @override
  List<Object> get props => [message];
}
