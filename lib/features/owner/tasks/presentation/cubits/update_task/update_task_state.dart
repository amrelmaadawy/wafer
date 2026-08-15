import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';

abstract class UpdateTaskState extends Equatable {
  const UpdateTaskState();

  @override
  List<Object?> get props => [];
}

class UpdateTaskInitial extends UpdateTaskState {}

class UpdateTaskLoading extends UpdateTaskState {}

class UpdateTaskSuccess extends UpdateTaskState {
  final TaskEntity task;

  const UpdateTaskSuccess(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskFailure extends UpdateTaskState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const UpdateTaskFailure(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, if (validationErrors != null) validationErrors];
}
