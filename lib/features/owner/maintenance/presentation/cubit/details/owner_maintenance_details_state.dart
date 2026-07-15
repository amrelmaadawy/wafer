import 'package:equatable/equatable.dart';
import '../../../domain/entities/maintenance_item_entity.dart';

abstract class OwnerMaintenanceDetailsState extends Equatable {
  const OwnerMaintenanceDetailsState();

  @override
  List<Object?> get props => [];
}

class OwnerMaintenanceDetailsInitial extends OwnerMaintenanceDetailsState {
  const OwnerMaintenanceDetailsInitial();
}

class OwnerMaintenanceDetailsLoading extends OwnerMaintenanceDetailsState {
  const OwnerMaintenanceDetailsLoading();
}

class OwnerMaintenanceDetailsLoaded extends OwnerMaintenanceDetailsState {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceDetailsLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class OwnerMaintenanceDetailsError extends OwnerMaintenanceDetailsState {
  final String message;

  const OwnerMaintenanceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
