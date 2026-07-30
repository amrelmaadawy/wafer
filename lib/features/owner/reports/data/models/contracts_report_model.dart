import '../../domain/entities/contracts_report_entity.dart';
import '../../domain/entities/contracts_report_item_entity.dart';
import '../../domain/entities/contracts_report_summary_entity.dart';
import 'report_pagination_model.dart';

class ContractsReportSummaryModel extends ContractsReportSummaryEntity {
  const ContractsReportSummaryModel({
    required super.totalExpiring,
    required super.totalRentValue,
    required super.days,
  });

  factory ContractsReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ContractsReportSummaryModel(
      totalExpiring: (json['total_expiring'] as num?)?.toInt() ?? 0,
      totalRentValue: (json['total_rent_value'] as num?)?.toDouble() ?? 0.0,
      days: (json['days'] as num?)?.toInt() ?? 0,
    );
  }
}

class ContractsReportItemModel extends ContractsReportItemEntity {
  const ContractsReportItemModel({
    required super.contractId,
    required super.contractNumber,
    required super.propertyName,
    required super.unitName,
    required super.renterName,
    required super.rentValue,
    required super.startDate,
    required super.endDate,
    required super.daysRemaining,
    required super.status,
  });

  factory ContractsReportItemModel.fromJson(Map<String, dynamic> json) {
    return ContractsReportItemModel(
      contractId: _parseInt(json['contract_id'] ?? json['id']),
      contractNumber: json['contract_number']?.toString() ?? '',
      propertyName: json['property_name']?.toString() ?? '',
      unitName: json['unit_name']?.toString() ?? '',
      renterName: json['renter_name']?.toString() ?? '',
      rentValue: _parseDouble(json['rent_value']),
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      daysRemaining: _parseInt(json['days_remaining']),
      status: json['status']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class ContractsReportModel extends ContractsReportEntity {
  const ContractsReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory ContractsReportModel.fromJson(Map<String, dynamic> json) {
    return ContractsReportModel(
      summary: ContractsReportSummaryModel.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ContractsReportItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
