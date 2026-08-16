import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class CreateTaskState extends Equatable {
  const CreateTaskState();

  @override
  List<Object?> get props => [];
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {
  final TaskEntity task;

  const CreateTaskSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class CreateTaskError extends CreateTaskState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const CreateTaskError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, if (validationErrors != null) validationErrors];
}
