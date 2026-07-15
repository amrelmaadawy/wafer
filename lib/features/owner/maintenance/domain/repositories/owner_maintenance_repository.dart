import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/maintenance_item_entity.dart';
import '../entities/maintenance_response_entity.dart';

abstract class OwnerMaintenanceRepository {
  Future<Either<Failure, MaintenanceResponseEntity>> getMaintenanceRequests({
    required int page,
    String? status,
    bool forceRefresh = false,
  });
  Future<Either<Failure, MaintenanceItemEntity>> getMaintenanceDetails(int id);
}
