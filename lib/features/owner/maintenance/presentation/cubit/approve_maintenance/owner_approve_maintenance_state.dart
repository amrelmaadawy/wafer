import 'package:equatable/equatable.dart';

abstract class OwnerApproveMaintenanceState extends Equatable {
  const OwnerApproveMaintenanceState();

  @override
  List<Object?> get props => [];
}

class OwnerApproveMaintenanceInitial extends OwnerApproveMaintenanceState {
  const OwnerApproveMaintenanceInitial();
}

class OwnerApproveMaintenanceLoading extends OwnerApproveMaintenanceState {
  const OwnerApproveMaintenanceLoading();
}

class OwnerApproveMaintenanceSuccess extends OwnerApproveMaintenanceState {
  final String message;
  const OwnerApproveMaintenanceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OwnerApproveMaintenanceError extends OwnerApproveMaintenanceState {
  final String message;
  const OwnerApproveMaintenanceError(this.message);

  @override
  List<Object?> get props => [message];
}
