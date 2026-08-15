import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class UpdateTaskStatusState extends Equatable {
  const UpdateTaskStatusState();

  @override
  List<Object?> get props => [];
}

class UpdateTaskStatusInitial extends UpdateTaskStatusState {}

class UpdateTaskStatusLoading extends UpdateTaskStatusState {}

class UpdateTaskStatusSuccess extends UpdateTaskStatusState {
  final TaskEntity task;

  const UpdateTaskStatusSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskStatusError extends UpdateTaskStatusState {
  final String message;

  const UpdateTaskStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
