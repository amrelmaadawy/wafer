import 'package:equatable/equatable.dart';
import '../../../maintenance/domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/owner_dashboard_entity.dart';

abstract class OwnerDashboardState extends Equatable {
  const OwnerDashboardState();

  @override
  List<Object?> get props => [];
}

class OwnerDashboardInitial extends OwnerDashboardState {
  const OwnerDashboardInitial();
}

class OwnerDashboardLoading extends OwnerDashboardState {
  const OwnerDashboardLoading();
}

class OwnerDashboardLoaded extends OwnerDashboardState {
  final OwnerDashboardEntity data;
  final List<MaintenanceItemEntity> recentMaintenanceItems;

  const OwnerDashboardLoaded(
    this.data, {
    this.recentMaintenanceItems = const [],
  });

  @override
  List<Object?> get props => [data, recentMaintenanceItems];
}

class OwnerDashboardError extends OwnerDashboardState {
  final String message;

  const OwnerDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
