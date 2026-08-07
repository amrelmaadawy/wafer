import '../../domain/entities/contracts_report_entity.dart';
import '../../domain/entities/contracts_report_item_entity.dart';
import '../../domain/entities/contracts_report_summary_entity.dart';
import 'report_pagination_model.dart';

class ContractsReportSummaryModel extends ContractsReportSummaryEntity {
  const ContractsReportSummaryModel({
    required super.total,
    required super.active,
    required super.expired,
    required super.expiringNext30Days,
    required super.totalRentValue,
  });

  factory ContractsReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ContractsReportSummaryModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      active: (json['active'] as num?)?.toInt() ?? 0,
      expired: (json['expired'] as num?)?.toInt() ?? 0,
      expiringNext30Days: (json['expiring_next_30_days'] as num?)?.toInt() ?? 0,
      totalRentValue: (json['total_rent_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ContractsReportItemModel extends ContractsReportItemEntity {
  const ContractsReportItemModel({
    required super.id,
    required super.contractNumber,
    required super.contractType,
    required super.propertyName,
    required super.unitName,
    required super.renterName,
    required super.startDate,
    required super.endDate,
    required super.totalRentValue,
    required super.status,
    required super.statusLabel,
  });

  factory ContractsReportItemModel.fromJson(Map<String, dynamic> json) {
    return ContractsReportItemModel(
      id: _parseInt(json['id']),
      contractNumber: json['contract_number']?.toString() ?? '',
      contractType: json['contract_type']?.toString() ?? '',
      propertyName: (json['property'] != null && json['property']['name'] != null)
          ? json['property']['name'].toString()
          : '',
      unitName: (json['unit'] != null && json['unit']['name'] != null)
          ? json['unit']['name'].toString()
          : '',
      renterName: (json['renter'] != null && json['renter']['name'] != null)
          ? json['renter']['name'].toString()
          : '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      totalRentValue: _parseDouble(json['total_rent_value']),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
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
    required super.filterOptions,
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
      filterOptions: ContractsFilterOptionsModel.fromJson(json['filter_options'] ?? {}),
    );
  }
}

class ContractsFilterOptionsModel extends ContractsFilterOptionsEntity {
  const ContractsFilterOptionsModel({
    required super.statuses,
    required super.properties,
  });

  factory ContractsFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return ContractsFilterOptionsModel(
      statuses: (json['statuses'] as List<dynamic>?)
              ?.map((e) => ContractsStatusFilterModel.fromJson(e))
              .toList() ??
          [],
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => ContractsPropertyFilterModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ContractsStatusFilterModel extends ContractsStatusFilterEntity {
  const ContractsStatusFilterModel({
    required super.value,
    required super.label,
  });

  factory ContractsStatusFilterModel.fromJson(Map<String, dynamic> json) {
    return ContractsStatusFilterModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class ContractsPropertyFilterModel extends ContractsPropertyFilterEntity {
  const ContractsPropertyFilterModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory ContractsPropertyFilterModel.fromJson(Map<String, dynamic> json) {
    return ContractsPropertyFilterModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString(),
      code: json['code']?.toString() ?? '',
    );
  }
}
