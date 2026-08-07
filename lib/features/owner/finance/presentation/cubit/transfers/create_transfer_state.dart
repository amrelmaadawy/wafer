part of 'create_transfer_cubit.dart';

abstract class CreateTransferState extends Equatable {
  const CreateTransferState();

  @override
  List<Object?> get props => [];
}

class CreateTransferInitial extends CreateTransferState {}

class CreateTransferLoading extends CreateTransferState {}

class CreateTransferSuccess extends CreateTransferState {}

class CreateTransferValidationError extends CreateTransferState {
  final String message;
  final Map<String, dynamic> errors;

  const CreateTransferValidationError({required this.message, required this.errors});

  @override
  List<Object?> get props => [message, errors];
}

class CreateTransferError extends CreateTransferState {
  final String message;

  const CreateTransferError({required this.message});

  @override
  List<Object?> get props => [message];
}
