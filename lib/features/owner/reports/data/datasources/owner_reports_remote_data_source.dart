import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/activity_logs_report_model.dart';
import '../models/approvals_report_model.dart';
import '../models/contracts_movement_report_model.dart';
import '../models/contracts_report_model.dart';
import '../models/defaulters_report_model.dart';
import '../models/employee_tasks_report_model.dart';
import '../models/legal_cases_report_model.dart';
import '../models/maintenance_requests_report_model.dart';
import '../models/occupancy_report_model.dart';
import '../models/owner_reports_index_model.dart';
import '../models/revenue_report_model.dart';
import '../models/technician_performance_report_model.dart';
import '../models/units_status_report_model.dart';

abstract class OwnerReportsRemoteDataSource {
  Future<OwnerReportsIndexModel> getReportsIndex();
  Future<RevenueReportModel> getRevenueReport({int? propertyId, String? startDate, String? endDate});
  Future<OccupancyReportModel> getOccupancyReport({int page = 1, int? propertyId, String? startDate, String? endDate});
  Future<DefaultersReportModel> getDefaultersReport({int page = 1, int? propertyId, String? startDate, String? endDate});
  Future<UnitsStatusReportModel> getUnitsStatusReport({int page = 1, int? propertyId, String? status});
  Future<ContractsReportModel> getContractsReport({int page = 1, int? propertyId, String? status, String? startDate, String? endDate});
  Future<ContractsMovementReportModel> getContractsMovementReport({int page = 1, String? startDate, String? endDate});
  Future<MaintenanceRequestsReportModel> getMaintenanceRequestsReport({int page = 1, String? status, String? startDate, String? endDate});
  Future<TechnicianPerformanceReportModel> getTechnicianPerformanceReport({int page = 1, String? startDate, String? endDate});
  Future<EmployeeTasksReportModel> getEmployeeTasksReport({int page = 1, String? status, String? startDate, String? endDate});
  Future<ActivityLogsReportModel> getActivityLogsReport({int page = 1, String? type, String? action, String? startDate, String? endDate});
  Future<ApprovalsReportModel> getApprovalsReport({int page = 1, String? status, String? startDate, String? endDate});
  Future<LegalCasesReportModel> getLegalCasesReport({int page = 1, String? status, String? startDate, String? endDate});
}

class OwnerReportsRemoteDataSourceImpl implements OwnerReportsRemoteDataSource {
  final Dio _dio;

  OwnerReportsRemoteDataSourceImpl(this._dio);

  Map<String, dynamic> _cleanParams(Map<String, dynamic> map) {
    return {
      for (final entry in map.entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value!,
    };
  }

  Future<Map<String, dynamic>> _fetch(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams?.isNotEmpty == true ? queryParams : null,
      );
      final data = response.data as Map<String, dynamic>? ?? {};
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      throw ServerException(data['message']?.toString() ?? 'Invalid response');
    } on DioException catch (e) {
      throw ServerException(e.response?.data?['message']?.toString() ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<OwnerReportsIndexModel> getReportsIndex() async {
    final json = await _fetch(ApiConstants.ownerReportsIndex);
    return OwnerReportsIndexModel.fromJson(json);
  }

  @override
  Future<RevenueReportModel> getRevenueReport({int? propertyId, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerRevenueReport, queryParams: _cleanParams({'property_id': propertyId, 'start_date': startDate, 'end_date': endDate}));
    return RevenueReportModel.fromJson(json);
  }

  @override
  Future<OccupancyReportModel> getOccupancyReport({int page = 1, int? propertyId, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerOccupancyReport, queryParams: _cleanParams({'page': page, 'property_id': propertyId, 'start_date': startDate, 'end_date': endDate}));
    return OccupancyReportModel.fromJson(json);
  }

  @override
  Future<DefaultersReportModel> getDefaultersReport({int page = 1, int? propertyId, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerDefaultersReport, queryParams: _cleanParams({'page': page, 'property_id': propertyId, 'start_date': startDate, 'end_date': endDate}));
    return DefaultersReportModel.fromJson(json);
  }

  @override
  Future<UnitsStatusReportModel> getUnitsStatusReport({int page = 1, int? propertyId, String? status}) async {
    final json = await _fetch(ApiConstants.ownerUnitsStatusReport, queryParams: _cleanParams({'page': page, 'property_id': propertyId, 'status': status}));
    return UnitsStatusReportModel.fromJson(json);
  }

  @override
  Future<ContractsReportModel> getContractsReport({int page = 1, int? propertyId, String? status, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerContractsReport, queryParams: _cleanParams({'page': page, 'property_id': propertyId, 'status': status, 'start_date': startDate, 'end_date': endDate}));
    return ContractsReportModel.fromJson(json);
  }

  @override
  Future<ContractsMovementReportModel> getContractsMovementReport({int page = 1, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerContractsMovementReport, queryParams: _cleanParams({'page': page, 'start_date': startDate, 'end_date': endDate}));
    return ContractsMovementReportModel.fromJson(json);
  }

  @override
  Future<MaintenanceRequestsReportModel> getMaintenanceRequestsReport({int page = 1, String? status, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerMaintenanceRequestsReport, queryParams: _cleanParams({'page': page, 'status': status, 'start_date': startDate, 'end_date': endDate}));
    return MaintenanceRequestsReportModel.fromJson(json);
  }

  @override
  Future<TechnicianPerformanceReportModel> getTechnicianPerformanceReport({int page = 1, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerTechnicianPerformanceReport, queryParams: _cleanParams({'page': page, 'start_date': startDate, 'end_date': endDate}));
    return TechnicianPerformanceReportModel.fromJson(json);
  }

  @override
  Future<EmployeeTasksReportModel> getEmployeeTasksReport({int page = 1, String? status, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerEmployeeTasksReport, queryParams: _cleanParams({'page': page, 'status': status, 'start_date': startDate, 'end_date': endDate}));
    return EmployeeTasksReportModel.fromJson(json);
  }

  @override
  Future<ActivityLogsReportModel> getActivityLogsReport({int page = 1, String? type, String? action, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerActivityLogsReport, queryParams: _cleanParams({'page': page, 'type': type, 'action': action, 'start_date': startDate, 'end_date': endDate}));
    return ActivityLogsReportModel.fromJson(json);
  }

  @override
  Future<ApprovalsReportModel> getApprovalsReport({int page = 1, String? status, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerApprovalsReport, queryParams: _cleanParams({'page': page, 'status': status, 'start_date': startDate, 'end_date': endDate}));
    return ApprovalsReportModel.fromJson(json);
  }

  @override
  Future<LegalCasesReportModel> getLegalCasesReport({int page = 1, String? status, String? startDate, String? endDate}) async {
    final json = await _fetch(ApiConstants.ownerReportsLegalCases, queryParams: _cleanParams({'page': page, 'status': status, 'start_date': startDate, 'end_date': endDate}));
    return LegalCasesReportModel.fromJson(json);
  }
}
