import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/maintenance_item_entity.dart';
import '../entities/maintenance_response_entity.dart';
import '../usecases/create_owner_maintenance_use_case.dart';
import '../usecases/update_owner_maintenance_use_case.dart';
import '../usecases/reject_owner_maintenance_use_case.dart';
import '../usecases/approve_owner_maintenance_use_case.dart';
import '../usecases/assign_owner_maintenance_use_case.dart';
import '../usecases/complete_owner_maintenance_task_use_case.dart';
import '../usecases/execute_owner_maintenance_use_case.dart';
import '../usecases/verify_close_owner_maintenance_use_case.dart';
import '../entities/maintenance_form_data_entity.dart';
import '../entities/execute_owner_maintenance_response_entity.dart';

abstract class OwnerMaintenanceRepository {
  Future<Either<Failure, MaintenanceFormDataEntity>> getFormData();
  Future<Either<Failure, MaintenanceResponseEntity>> getMaintenanceRequests({
    required int page,
    String? status,
    bool forceRefresh = false,
  });
  Future<Either<Failure, MaintenanceItemEntity>> getMaintenanceDetails(int id);
  Future<Either<Failure, void>> createMaintenanceRequest(
    CreateOwnerMaintenanceParams params,
  );
  Future<Either<Failure, MaintenanceItemEntity>> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  );
  Future<Either<Failure, void>> approveMaintenanceRequest(
    ApproveOwnerMaintenanceParams params,
  );
  Future<Either<Failure, void>> deleteMaintenanceRequest(int id);
  Future<Either<Failure, void>> rejectMaintenanceRequest(
    RejectOwnerMaintenanceParams params,
  );
  Future<Either<Failure, void>> assignMaintenanceRequest(
    AssignOwnerMaintenanceParams params,
  );
  Future<Either<Failure, MaintenanceItemEntity>> startMaintenanceRequest(
    int id,
  );
  Future<Either<Failure, MaintenanceItemEntity>> completeMaintenanceTask(
    CompleteOwnerMaintenanceTaskParams params,
  );
  Future<Either<Failure, ExecuteOwnerMaintenanceResponseEntity>>
  executeMaintenanceRequest(ExecuteOwnerMaintenanceParams params);
  Future<Either<Failure, MaintenanceItemEntity>> verifyCloseMaintenanceRequest(
    VerifyCloseOwnerMaintenanceParams params,
  );
}
