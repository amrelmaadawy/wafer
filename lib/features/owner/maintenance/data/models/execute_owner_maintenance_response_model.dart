import '../../domain/entities/execute_owner_maintenance_response_entity.dart';
import 'maintenance_item_model.dart';

class ExecuteOwnerMaintenanceResponseModel extends ExecuteOwnerMaintenanceResponseEntity {
  const ExecuteOwnerMaintenanceResponseModel({
    required super.maintenanceRequest,
    required super.qaCode,
  });

  factory ExecuteOwnerMaintenanceResponseModel.fromJson(Map<String, dynamic> json) {
    return ExecuteOwnerMaintenanceResponseModel(
      maintenanceRequest: MaintenanceItemModel.fromJson(json['maintenance_request']),
      qaCode: json['qa_code'] as String,
    );
  }
}
