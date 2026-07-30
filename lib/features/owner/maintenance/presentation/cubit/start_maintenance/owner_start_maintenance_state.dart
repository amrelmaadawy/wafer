import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_item_entity.dart';

abstract class OwnerStartMaintenanceState extends Equatable {
  const OwnerStartMaintenanceState();

  @override
  List<Object?> get props => [];
}

class OwnerStartMaintenanceInitial extends OwnerStartMaintenanceState {}

class OwnerStartMaintenanceLoading extends OwnerStartMaintenanceState {}

class OwnerStartMaintenanceSuccess extends OwnerStartMaintenanceState {
  final MaintenanceItemEntity item;

  const OwnerStartMaintenanceSuccess(this.item);

  @override
  List<Object?> get props => [item];
}

class OwnerStartMaintenanceError extends OwnerStartMaintenanceState {
  final String message;

  const OwnerStartMaintenanceError(this.message);

  @override
  List<Object?> get props => [message];
}
