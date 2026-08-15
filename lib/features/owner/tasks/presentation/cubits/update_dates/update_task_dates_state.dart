import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class UpdateTaskDatesState extends Equatable {
  const UpdateTaskDatesState();

  @override
  List<Object> get props => [];
}

class UpdateTaskDatesInitial extends UpdateTaskDatesState {}

class UpdateTaskDatesLoading extends UpdateTaskDatesState {}

class UpdateTaskDatesSuccess extends UpdateTaskDatesState {
  final TaskEntity task;

  const UpdateTaskDatesSuccess({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskDatesError extends UpdateTaskDatesState {
  final String message;

  const UpdateTaskDatesError({required this.message});

  @override
  List<Object> get props => [message];
}
