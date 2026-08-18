import 'package:dartz/dartz.dart';
import '../entities/owner_reports_index_entity.dart';
import '../../../../../core/error/failures.dart';
import '../entities/defaulters_report_entity.dart';
import '../entities/occupancy_report_entity.dart';
import '../entities/revenue_report_entity.dart';
import '../entities/units_status_report_entity.dart';
import '../entities/contracts_report_entity.dart';
import '../entities/contracts_movement_report_entity.dart';
import '../entities/maintenance_requests_report_entity.dart';
import '../entities/technician_performance_report_entity.dart';
import '../entities/employee_tasks_report_entity.dart';
import '../entities/activity_logs_report_entity.dart';
import '../entities/approvals_report_entity.dart';
import '../entities/legal_cases_report_entity.dart';

abstract class OwnerReportsRepository {
  Future<Either<Failure, OwnerReportsIndexEntity>> getReportsIndex();

  Future<Either<Failure, RevenueReportEntity>> getRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, OccupancyReportEntity>> getOccupancyReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, DefaultersReportEntity>> getDefaultersReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? startDate,
    String? endDate,
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
    String? status,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, ContractsMovementReportEntity>>
  getContractsMovementReport({
    bool forceRefresh = false,
    int page = 1,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, MaintenanceRequestsReportEntity>>
  getMaintenanceRequestsReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, TechnicianPerformanceReportEntity>>
  getTechnicianPerformanceReport({
    bool forceRefresh = false,
    int page = 1,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, EmployeeTasksReportEntity>> getEmployeeTasksReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, ActivityLogsReportEntity>> getActivityLogsReport({
    bool forceRefresh = false,
    int page = 1,
    String? type,
    String? action,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, ApprovalsReportEntity>> getApprovalsReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, LegalCasesReportEntity>> getLegalCasesReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  });
}
