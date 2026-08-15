import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class UpdateTaskProgressState extends Equatable {
  const UpdateTaskProgressState();

  @override
  List<Object> get props => [];
}

class UpdateTaskProgressInitial extends UpdateTaskProgressState {}

class UpdateTaskProgressLoading extends UpdateTaskProgressState {}

class UpdateTaskProgressSuccess extends UpdateTaskProgressState {
  final TaskEntity task;

  const UpdateTaskProgressSuccess(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskProgressError extends UpdateTaskProgressState {
  final String message;

  const UpdateTaskProgressError(this.message);

  @override
  List<Object> get props => [message];
}
