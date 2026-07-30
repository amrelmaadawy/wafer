import 'package:equatable/equatable.dart';

abstract class OwnerUpdateMaintenanceState extends Equatable {
  const OwnerUpdateMaintenanceState();

  @override
  List<Object?> get props => [];
}

class OwnerUpdateMaintenanceInitial extends OwnerUpdateMaintenanceState {
  const OwnerUpdateMaintenanceInitial();
}

class OwnerUpdateMaintenanceLoading extends OwnerUpdateMaintenanceState {
  const OwnerUpdateMaintenanceLoading();
}

class OwnerUpdateMaintenanceSuccess extends OwnerUpdateMaintenanceState {
  final String message;

  const OwnerUpdateMaintenanceSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class OwnerUpdateMaintenanceError extends OwnerUpdateMaintenanceState {
  final String message;

  const OwnerUpdateMaintenanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
