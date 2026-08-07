import 'package:equatable/equatable.dart';
import '../../../domain/entities/transfer_entity.dart';

abstract class UpdateTransferState extends Equatable {
  const UpdateTransferState();

  @override
  List<Object> get props => [];
}

class UpdateTransferInitial extends UpdateTransferState {}

class UpdateTransferLoading extends UpdateTransferState {}

class UpdateTransferSuccess extends UpdateTransferState {
  final TransferEntity transfer;
  final String message;

  const UpdateTransferSuccess({required this.transfer, required this.message});

  @override
  List<Object> get props => [transfer, message];
}

class UpdateTransferError extends UpdateTransferState {
  final String message;

  const UpdateTransferError(this.message);

  @override
  List<Object> get props => [message];
}
