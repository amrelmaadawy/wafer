import 'package:equatable/equatable.dart';

abstract class OwnerAssignMaintenanceState extends Equatable {
  const OwnerAssignMaintenanceState();

  @override
  List<Object?> get props => [];
}

class OwnerAssignMaintenanceInitial extends OwnerAssignMaintenanceState {}

class OwnerAssignMaintenanceLoading extends OwnerAssignMaintenanceState {}

class OwnerAssignMaintenanceSuccess extends OwnerAssignMaintenanceState {
  final String message;

  const OwnerAssignMaintenanceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OwnerAssignMaintenanceError extends OwnerAssignMaintenanceState {
  final String message;

  const OwnerAssignMaintenanceError(this.message);

  @override
  List<Object?> get props => [message];
}
