import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_form_data_entity.dart';

abstract class TaskFormDataState extends Equatable {
  const TaskFormDataState();

  @override
  List<Object?> get props => [];
}

class TaskFormDataInitial extends TaskFormDataState {}

class TaskFormDataLoading extends TaskFormDataState {}

class TaskFormDataLoaded extends TaskFormDataState {
  final TaskFormDataEntity formData;

  const TaskFormDataLoaded(this.formData);

  @override
  List<Object?> get props => [formData];
}

class TaskFormDataError extends TaskFormDataState {
  final String message;

  const TaskFormDataError(this.message);

  @override
  List<Object?> get props => [message];
}
