import '../../domain/entities/owner_reports_index_entity.dart';

class OwnerReportsIndexModel extends OwnerReportsIndexEntity {
  const OwnerReportsIndexModel({
    required super.stats,
    required super.reports,
    required super.filterOptions,
  });

  factory OwnerReportsIndexModel.fromJson(Map<String, dynamic> json) {
    return OwnerReportsIndexModel(
      stats: ReportStatsModel.fromJson(json['stats'] ?? {}),
      reports:
          (json['reports'] as List<dynamic>?)
              ?.map((e) => ReportMetaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      filterOptions: ReportFilterOptionsModel.fromJson(
        json['filter_options'] ?? {},
      ),
    );
  }
}

class ReportStatsModel extends ReportStatsEntity {
  const ReportStatsModel({
    required super.totalProperties,
    required super.totalUnits,
    required super.totalContracts,
    required super.activeContracts,
    required super.openMaintenance,
    required super.activeCases,
  });

  factory ReportStatsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatsModel(
      totalProperties: json['total_properties'] ?? 0,
      totalUnits: json['total_units'] ?? 0,
      totalContracts: json['total_contracts'] ?? 0,
      activeContracts: json['active_contracts'] ?? 0,
      openMaintenance: json['open_maintenance'] ?? 0,
      activeCases: json['active_cases'] ?? 0,
    );
  }
}

class ReportMetaModel extends ReportMetaEntity {
  const ReportMetaModel({
    required super.key,
    required super.name,
    required super.method,
    required super.path,
    required super.v1MobilePath,
    required super.filters,
  });

  factory ReportMetaModel.fromJson(Map<String, dynamic> json) {
    return ReportMetaModel(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      method: json['method'] ?? '',
      path: json['path'] ?? '',
      v1MobilePath: json['v1_mobile_path'] ?? '',
      filters:
          (json['filters'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ReportFilterOptionsModel extends ReportFilterOptionsEntity {
  const ReportFilterOptionsModel({
    required super.properties,
    required super.unitStatuses,
    required super.contractStatuses,
    required super.maintenanceStatuses,
    required super.maintenancePriorities,
  });

  factory ReportFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return ReportFilterOptionsModel(
      properties:
          (json['properties'] as List<dynamic>?)
              ?.map(
                (e) => ReportFilterPropertyModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      unitStatuses:
          (json['unit_statuses'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReportFilterOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      contractStatuses:
          (json['contract_statuses'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReportFilterOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      maintenanceStatuses:
          (json['maintenance_statuses'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReportFilterOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      maintenancePriorities:
          (json['maintenance_priorities'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReportFilterOptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class ReportFilterPropertyModel extends ReportFilterPropertyEntity {
  const ReportFilterPropertyModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory ReportFilterPropertyModel.fromJson(Map<String, dynamic> json) {
    return ReportFilterPropertyModel(
      id: json['id'] ?? 0,
      name: json['name'],
      code: json['code'] ?? '',
    );
  }
}

class ReportFilterOptionModel extends ReportFilterOptionEntity {
  const ReportFilterOptionModel({required super.value, required super.label});

  factory ReportFilterOptionModel.fromJson(Map<String, dynamic> json) {
    return ReportFilterOptionModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}
