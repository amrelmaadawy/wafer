import '../../domain/entities/units_status_filter_options_entity.dart';
import '../../domain/entities/units_status_item_entity.dart';
import '../../domain/entities/units_status_property_entity.dart';
import '../../domain/entities/units_status_report_entity.dart';
import '../../domain/entities/units_status_summary_entity.dart';
import 'report_pagination_model.dart';

class UnitsStatusReportModel extends UnitsStatusReportEntity {
  const UnitsStatusReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.filterOptions,
  });

  factory UnitsStatusReportModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusReportModel(
      summary: UnitsStatusSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => UnitsStatusItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(json['pagination'] ?? {}),
      filterOptions: UnitsStatusFilterOptionsModel.fromJson(
          json['filter_options'] ?? {}),
    );
  }
}

class UnitsStatusSummaryModel extends UnitsStatusSummaryEntity {
  const UnitsStatusSummaryModel({
    required super.total,
    required super.vacant,
    required super.rented,
    required super.maintenance,
  });

  factory UnitsStatusSummaryModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusSummaryModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      vacant: (json['vacant'] as num?)?.toInt() ?? 0,
      rented: (json['rented'] as num?)?.toInt() ?? 0,
      maintenance: (json['maintenance'] as num?)?.toInt() ?? 0,
    );
  }
}

class UnitsStatusItemModel extends UnitsStatusItemEntity {
  const UnitsStatusItemModel({
    required super.id,
    required super.unitNumber,
    required super.name,
    required super.code,
    required super.property,
    super.floorNumber,
    required super.status,
    required super.statusLabel,
    super.activeContract,
    required super.createdAt,
  });

  factory UnitsStatusItemModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      unitNumber: json['unit_number']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      property: UnitsStatusPropertyModel.fromJson(json['property'] ?? {}),
      floorNumber: (json['floor_number'] as num?)?.toInt(),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      activeContract: json['active_contract'],
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class UnitsStatusPropertyModel extends UnitsStatusPropertyEntity {
  const UnitsStatusPropertyModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory UnitsStatusPropertyModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusPropertyModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

class UnitsStatusFilterOptionsModel extends UnitsStatusFilterOptionsEntity {
  const UnitsStatusFilterOptionsModel({
    required super.statuses,
    required super.properties,
  });

  factory UnitsStatusFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusFilterOptionsModel(
      statuses: (json['statuses'] as List<dynamic>?)
              ?.map((e) => UnitsStatusStatusFilterModel.fromJson(e))
              .toList() ??
          [],
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => UnitsStatusPropertyFilterModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UnitsStatusStatusFilterModel extends UnitsStatusStatusFilterEntity {
  const UnitsStatusStatusFilterModel({
    required super.value,
    required super.label,
  });

  factory UnitsStatusStatusFilterModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusStatusFilterModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class UnitsStatusPropertyFilterModel extends UnitsStatusPropertyFilterEntity {
  const UnitsStatusPropertyFilterModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory UnitsStatusPropertyFilterModel.fromJson(Map<String, dynamic> json) {
    return UnitsStatusPropertyFilterModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString(),
      code: json['code']?.toString() ?? '',
    );
  }
}
