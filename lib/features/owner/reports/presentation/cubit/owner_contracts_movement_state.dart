import 'package:equatable/equatable.dart';
import '../../domain/entities/contracts_movement_report_entity.dart';

abstract class OwnerContractsMovementState extends Equatable {
  const OwnerContractsMovementState();

  @override
  List<Object?> get props => [];
}

class OwnerContractsMovementInitial extends OwnerContractsMovementState {}

class OwnerContractsMovementLoading extends OwnerContractsMovementState {
  final bool isPagination;
  const OwnerContractsMovementLoading({this.isPagination = false});

  @override
  List<Object?> get props => [isPagination];
}

class OwnerContractsMovementLoaded extends OwnerContractsMovementState {
  final ContractsMovementReportEntity report;
  final bool hasReachedMax;

  const OwnerContractsMovementLoaded({
    required this.report,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [report, hasReachedMax];
}

class OwnerContractsMovementEmpty extends OwnerContractsMovementState {}

class OwnerContractsMovementError extends OwnerContractsMovementState {
  final String message;
  const OwnerContractsMovementError(this.message);

  @override
  List<Object?> get props => [message];
}
