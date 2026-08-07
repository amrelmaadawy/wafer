import 'package:equatable/equatable.dart';
import '../../../domain/entities/transfer_entity.dart';

abstract class ApproveTransferState extends Equatable {
  const ApproveTransferState();

  @override
  List<Object> get props => [];
}

class ApproveTransferInitial extends ApproveTransferState {}

class ApproveTransferLoading extends ApproveTransferState {}

class ApproveTransferSuccess extends ApproveTransferState {
  final TransferEntity transfer;
  final String message;

  const ApproveTransferSuccess({required this.transfer, required this.message});

  @override
  List<Object> get props => [transfer, message];
}

class ApproveTransferError extends ApproveTransferState {
  final String message;

  const ApproveTransferError(this.message);

  @override
  List<Object> get props => [message];
}
