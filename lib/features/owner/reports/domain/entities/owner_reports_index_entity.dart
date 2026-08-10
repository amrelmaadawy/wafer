import 'package:equatable/equatable.dart';

class OwnerReportsIndexEntity extends Equatable {
  final ReportStatsEntity stats;
  final List<ReportMetaEntity> reports;
  final ReportFilterOptionsEntity filterOptions;

  const OwnerReportsIndexEntity({
    required this.stats,
    required this.reports,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [stats, reports, filterOptions];
}

class ReportStatsEntity extends Equatable {
  final int totalProperties;
  final int totalUnits;
  final int totalContracts;
  final int activeContracts;
  final int openMaintenance;
  final int activeCases;

  const ReportStatsEntity({
    required this.totalProperties,
    required this.totalUnits,
    required this.totalContracts,
    required this.activeContracts,
    required this.openMaintenance,
    required this.activeCases,
  });

  @override
  List<Object?> get props => [
        totalProperties,
        totalUnits,
        totalContracts,
        activeContracts,
        openMaintenance,
        activeCases,
      ];
}

class ReportMetaEntity extends Equatable {
  final String key;
  final String name;
  final String method;
  final String path;
  final String v1MobilePath;
  final List<String> filters;

  const ReportMetaEntity({
    required this.key,
    required this.name,
    required this.method,
    required this.path,
    required this.v1MobilePath,
    required this.filters,
  });

  @override
  List<Object?> get props => [key, name, method, path, v1MobilePath, filters];
}

class ReportFilterOptionsEntity extends Equatable {
  final List<ReportFilterPropertyEntity> properties;
  final List<ReportFilterOptionEntity> unitStatuses;
  final List<ReportFilterOptionEntity> contractStatuses;
  final List<ReportFilterOptionEntity> maintenanceStatuses;
  final List<ReportFilterOptionEntity> maintenancePriorities;

  const ReportFilterOptionsEntity({
    required this.properties,
    required this.unitStatuses,
    required this.contractStatuses,
    required this.maintenanceStatuses,
    required this.maintenancePriorities,
  });

  @override
  List<Object?> get props => [
        properties,
        unitStatuses,
        contractStatuses,
        maintenanceStatuses,
        maintenancePriorities,
      ];
}

class ReportFilterPropertyEntity extends Equatable {
  final int id;
  final String? name;
  final String code;

  const ReportFilterPropertyEntity({
    required this.id,
    this.name,
    required this.code,
  });
  
  String get displayName => name ?? code;

  @override
  List<Object?> get props => [id, name, code];
}

class ReportFilterOptionEntity extends Equatable {
  final String value;
  final String label;

  const ReportFilterOptionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}
