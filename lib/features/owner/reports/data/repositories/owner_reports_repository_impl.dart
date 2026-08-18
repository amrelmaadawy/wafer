import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/activity_logs_report_entity.dart';
import '../../domain/entities/approvals_report_entity.dart';
import '../../domain/entities/contracts_movement_report_entity.dart';
import '../../domain/entities/contracts_report_entity.dart';
import '../../domain/entities/defaulters_report_entity.dart';
import '../../domain/entities/employee_tasks_report_entity.dart';
import '../../domain/entities/legal_cases_report_entity.dart';
import '../../domain/entities/maintenance_requests_report_entity.dart';
import '../../domain/entities/occupancy_report_entity.dart';
import '../../domain/entities/owner_reports_index_entity.dart';
import '../../domain/entities/revenue_report_entity.dart';
import '../../domain/entities/technician_performance_report_entity.dart';
import '../../domain/entities/units_status_report_entity.dart';
import '../../domain/repositories/owner_reports_repository.dart';
import '../datasources/owner_reports_remote_data_source.dart';

class OwnerReportsRepositoryImpl implements OwnerReportsRepository {
  final OwnerReportsRemoteDataSource _remoteDataSource;

  OwnerReportsRepositoryImpl(this._remoteDataSource);

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OwnerReportsIndexEntity>> getReportsIndex() =>
      _execute(() => _remoteDataSource.getReportsIndex());

  @override
  Future<Either<Failure, RevenueReportEntity>> getRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getRevenueReport(
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, OccupancyReportEntity>> getOccupancyReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getOccupancyReport(
        page: page,
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, DefaultersReportEntity>> getDefaultersReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getDefaultersReport(
        page: page,
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, UnitsStatusReportEntity>> getUnitsStatusReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? status,
  }) => _execute(() => _remoteDataSource.getUnitsStatusReport(
        page: page,
        propertyId: propertyId,
        status: status,
      ));

  @override
  Future<Either<Failure, ContractsReportEntity>> getContractsReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? status,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getContractsReport(
        page: page,
        propertyId: propertyId,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, ContractsMovementReportEntity>>
  getContractsMovementReport({
    bool forceRefresh = false,
    int page = 1,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getContractsMovementReport(
        page: page,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, MaintenanceRequestsReportEntity>>
  getMaintenanceRequestsReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getMaintenanceRequestsReport(
        page: page,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, TechnicianPerformanceReportEntity>>
  getTechnicianPerformanceReport({
    bool forceRefresh = false,
    int page = 1,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getTechnicianPerformanceReport(
        page: page,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, EmployeeTasksReportEntity>> getEmployeeTasksReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getEmployeeTasksReport(
        page: page,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, ActivityLogsReportEntity>> getActivityLogsReport({
    bool forceRefresh = false,
    int page = 1,
    String? type,
    String? action,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getActivityLogsReport(
        page: page,
        type: type,
        action: action,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, ApprovalsReportEntity>> getApprovalsReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getApprovalsReport(
        page: page,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ));

  @override
  Future<Either<Failure, LegalCasesReportEntity>> getLegalCasesReport({
    bool forceRefresh = false,
    int page = 1,
    String? status,
    String? startDate,
    String? endDate,
  }) => _execute(() => _remoteDataSource.getLegalCasesReport(
        page: page,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ));
}
