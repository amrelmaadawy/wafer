import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class AddTaskCommentState extends Equatable {
  const AddTaskCommentState();

  @override
  List<Object> get props => [];
}

class AddTaskCommentInitial extends AddTaskCommentState {}

class AddTaskCommentLoading extends AddTaskCommentState {}

class AddTaskCommentSuccess extends AddTaskCommentState {
  final TaskEntity task;

  const AddTaskCommentSuccess({required this.task});

  @override
  List<Object> get props => [task];
}

class AddTaskCommentError extends AddTaskCommentState {
  final String message;

  const AddTaskCommentError({required this.message});

  @override
  List<Object> get props => [message];
}
