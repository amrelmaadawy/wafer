import 'package:equatable/equatable.dart';

abstract class CreateSupervisorState extends Equatable {
  const CreateSupervisorState();

  @override
  List<Object> get props => [];
}

class CreateSupervisorInitial extends CreateSupervisorState {}

class CreateSupervisorLoading extends CreateSupervisorState {}

class CreateSupervisorSuccess extends CreateSupervisorState {
  final String message;

  const CreateSupervisorSuccess({
    this.message = 'Supervisor created successfully',
  });

  @override
  List<Object> get props => [message];
}

class CreateSupervisorError extends CreateSupervisorState {
  final String message;

  const CreateSupervisorError(this.message);

  @override
  List<Object> get props => [message];
}
