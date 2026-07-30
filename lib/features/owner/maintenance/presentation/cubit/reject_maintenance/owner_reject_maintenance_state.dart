import 'package:equatable/equatable.dart';

abstract class OwnerRejectMaintenanceState extends Equatable {
  const OwnerRejectMaintenanceState();

  @override
  List<Object> get props => [];
}

class OwnerRejectMaintenanceInitial extends OwnerRejectMaintenanceState {
  const OwnerRejectMaintenanceInitial();
}

class OwnerRejectMaintenanceLoading extends OwnerRejectMaintenanceState {
  const OwnerRejectMaintenanceLoading();
}

class OwnerRejectMaintenanceSuccess extends OwnerRejectMaintenanceState {
  final String message;

  const OwnerRejectMaintenanceSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OwnerRejectMaintenanceError extends OwnerRejectMaintenanceState {
  final String message;

  const OwnerRejectMaintenanceError(this.message);

  @override
  List<Object> get props => [message];
}
