import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulters_report_entity.dart';
import '../entities/occupancy_report_entity.dart';
import '../entities/revenue_report_entity.dart';
import '../entities/units_status_report_entity.dart';
import '../entities/contracts_report_entity.dart';
import '../entities/contracts_movement_report_entity.dart';
import '../entities/maintenance_requests_report_entity.dart';

abstract class OwnerReportsRepository {
  Future<Either<Failure, RevenueReportEntity>> getRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, OccupancyReportEntity>> getOccupancyReport({
    bool forceRefresh = false,
    int page = 1,
  });

  Future<Either<Failure, DefaultersReportEntity>> getDefaultersReport({
    bool forceRefresh = false,
    int page = 1,
  });

  Future<Either<Failure, UnitsStatusReportEntity>> getUnitsStatusReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? status,
  });

  Future<Either<Failure, ContractsReportEntity>> getContractsReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
  });

  Future<Either<Failure, ContractsMovementReportEntity>> getContractsMovementReport({
    bool forceRefresh = false,
    int page = 1,
  });

  Future<Either<Failure, MaintenanceRequestsReportEntity>> getMaintenanceRequestsReport({
    bool forceRefresh = false,
    int page = 1,
  });
}
