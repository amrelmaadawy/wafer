import '../../domain/entities/units_status_item_entity.dart';
import '../../domain/entities/units_status_property_entity.dart';
import '../../domain/entities/units_status_report_entity.dart';
import '../../domain/entities/units_status_summary_entity.dart';
import 'report_model_parsing.dart';
import 'report_pagination_model.dart';
import 'units_status_filter_options_model.dart';

class UnitsStatusReportModel extends UnitsStatusReportEntity {
  const UnitsStatusReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
    required super.filterOptions,
  });

  factory UnitsStatusReportModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'];
    final pagination = json['pagination'];
    final filters = json['filter_options'];
    return UnitsStatusReportModel(
      summary: UnitsStatusSummaryModel.fromJson(
        summary is Map<String, dynamic> ? summary : const {},
      ),
      items:
          (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(UnitsStatusItemModel.fromJson)
              .toList() ??
          [],
      pagination: ReportPaginationModel.fromJson(
        pagination is Map<String, dynamic> ? pagination : const {},
      ),
      filterOptions: UnitsStatusFilterOptionsModel.fromJson(
        filters is Map<String, dynamic> ? filters : const {},
      ),
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
      total: reportInt(json['total']),
      vacant: reportInt(json['vacant']),
      rented: reportInt(json['rented']),
      maintenance: reportInt(json['maintenance']),
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
    required super.createdAt,
  });

  factory UnitsStatusItemModel.fromJson(Map<String, dynamic> json) {
    final property = json['property'];
    return UnitsStatusItemModel(
      id: reportInt(json['id']),
      unitNumber: json['unit_number']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      property: UnitsStatusPropertyModel.fromJson(
        property is Map<String, dynamic> ? property : const {},
      ),
      floorNumber: reportNullableInt(json['floor_number']),
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
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
      id: reportInt(json['id']),
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}
