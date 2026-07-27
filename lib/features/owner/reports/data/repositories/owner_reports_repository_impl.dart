import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/features/owner/reports/domain/entities/units_status_report_entity.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/defaulters_report_entity.dart';
import '../../domain/entities/maintenance_requests_report_entity.dart';
import '../../domain/entities/technician_performance_report_entity.dart';
import '../../domain/entities/employee_tasks_report_entity.dart';
import '../../domain/entities/activity_logs_report_entity.dart';
import '../../domain/entities/contracts_report_entity.dart';
import '../../domain/entities/contracts_movement_report_entity.dart';
import '../../domain/entities/occupancy_report_entity.dart';
import '../models/revenue_report_model.dart';
import '../../domain/repositories/owner_reports_repository.dart';
import '../datasources/owner_reports_remote_data_source.dart';

class OwnerReportsRepositoryImpl implements OwnerReportsRepository {
  final OwnerReportsRemoteDataSource _remoteDataSource;

  OwnerReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RevenueReportModel>> getRevenueReport({
    bool forceRefresh = false,
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final result = await _remoteDataSource.getRevenueReport(
        propertyId: propertyId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      final msg = serverMsg ?? 
          (e.type == DioExceptionType.badResponse 
              ? LocaleKeys.errorsServerError.tr() 
              : e.message) ?? 
          LocaleKeys.errorsServerError.tr();
      return Left(ServerFailure(msg));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OccupancyReportEntity>> getOccupancyReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getOccupancyReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      final msg = serverMsg ?? 
          (e.type == DioExceptionType.badResponse 
              ? LocaleKeys.errorsServerError.tr() 
              : e.message) ?? 
          LocaleKeys.errorsServerError.tr();
      return Left(ServerFailure(msg));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DefaultersReportEntity>> getDefaultersReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getDefaultersReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      final msg = serverMsg ?? 
          (e.type == DioExceptionType.badResponse 
              ? LocaleKeys.errorsServerError.tr() 
              : e.message) ?? 
          LocaleKeys.errorsServerError.tr();
      return Left(ServerFailure(msg));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UnitsStatusReportEntity>> getUnitsStatusReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.getUnitsStatusReport(
        page: page,
        propertyId: propertyId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String? serverMsg;
      if (e.response?.data is Map<String, dynamic>) {
        serverMsg =
            (e.response?.data as Map<String, dynamic>)['message'] as String?;
      }
      final msg = serverMsg ?? 
          (e.type == DioExceptionType.badResponse 
              ? LocaleKeys.errorsServerError.tr() 
              : e.message) ?? 
          LocaleKeys.errorsServerError.tr();
      return Left(ServerFailure(msg));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractsReportEntity>> getContractsReport({
    bool forceRefresh = false,
    int page = 1,
    int? propertyId,
  }) async {
    try {
      final model = await _remoteDataSource.getContractsReport(
        page: page,
        propertyId: propertyId,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractsMovementReportEntity>> getContractsMovementReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getContractsMovementReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, MaintenanceRequestsReportEntity>> getMaintenanceRequestsReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getMaintenanceRequestsReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, TechnicianPerformanceReportEntity>> getTechnicianPerformanceReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getTechnicianPerformanceReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeTasksReportEntity>> getEmployeeTasksReport({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final result = await _remoteDataSource.getEmployeeTasksReport(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityLogsReportEntity>> getActivityLogsReport({
    bool forceRefresh = false,
    int page = 1,
    String? type,
    String? action,
  }) async {
    try {
      final result = await _remoteDataSource.getActivityLogsReport(
        page: page,
        type: type,
        action: action,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
