import 'package:equatable/equatable.dart';
import 'maintenance_item_entity.dart';

class ExecuteOwnerMaintenanceResponseEntity extends Equatable {
  final MaintenanceItemEntity maintenanceRequest;
  final String qaCode;

  const ExecuteOwnerMaintenanceResponseEntity({
    required this.maintenanceRequest,
    required this.qaCode,
  });

  @override
  List<Object?> get props => [maintenanceRequest, qaCode];
}
