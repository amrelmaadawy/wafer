import 'package:equatable/equatable.dart';

abstract class OwnerForwardMaintenanceState extends Equatable {
  const OwnerForwardMaintenanceState();

  @override
  List<Object> get props => [];
}

class OwnerForwardMaintenanceInitial extends OwnerForwardMaintenanceState {
  const OwnerForwardMaintenanceInitial();
}

class OwnerForwardMaintenanceLoading extends OwnerForwardMaintenanceState {
  const OwnerForwardMaintenanceLoading();
}

class OwnerForwardMaintenanceSuccess extends OwnerForwardMaintenanceState {
  final String message;

  const OwnerForwardMaintenanceSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OwnerForwardMaintenanceError extends OwnerForwardMaintenanceState {
  final String message;

  const OwnerForwardMaintenanceError(this.message);

  @override
  List<Object> get props => [message];
}
