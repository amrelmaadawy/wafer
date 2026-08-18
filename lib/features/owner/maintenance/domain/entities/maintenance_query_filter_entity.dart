import 'package:equatable/equatable.dart';

enum MaintenanceSortField { date, priority, requestNumber }

class MaintenanceQueryFilterEntity extends Equatable {
  final String? search;
  final String? status;
  final String? priority;
  final int? typeId;
  final String? typeName;
  final String? costBearer;
  final int? propertyId;
  final String? propertyName;
  final int? unitId;
  final int? technicianId;
  final String? technicianName;
  final String? date;
  final MaintenanceSortField? sortBy;
  final bool sortAscending;
  final int page;

  const MaintenanceQueryFilterEntity({
    this.search,
    this.status,
    this.priority,
    this.typeId,
    this.typeName,
    this.costBearer,
    this.propertyId,
    this.propertyName,
    this.unitId,
    this.technicianId,
    this.technicianName,
    this.date,
    this.sortBy,
    this.sortAscending = false,
    this.page = 1,
  });

  MaintenanceQueryFilterEntity copyWith({
    String? Function()? search,
    String? Function()? status,
    String? Function()? priority,
    int? Function()? typeId,
    String? Function()? typeName,
    String? Function()? costBearer,
    int? Function()? propertyId,
    String? Function()? propertyName,
    int? Function()? unitId,
    int? Function()? technicianId,
    String? Function()? technicianName,
    String? Function()? date,
    MaintenanceSortField? Function()? sortBy,
    bool? sortAscending,
    int? page,
  }) {
    return MaintenanceQueryFilterEntity(
      search: search != null ? search() : this.search,
      status: status != null ? status() : this.status,
      priority: priority != null ? priority() : this.priority,
      typeId: typeId != null ? typeId() : this.typeId,
      typeName: typeName != null ? typeName() : this.typeName,
      costBearer: costBearer != null ? costBearer() : this.costBearer,
      propertyId: propertyId != null ? propertyId() : this.propertyId,
      propertyName: propertyName != null ? propertyName() : this.propertyName,
      unitId: unitId != null ? unitId() : this.unitId,
      technicianId: technicianId != null ? technicianId() : this.technicianId,
      technicianName:
          technicianName != null ? technicianName() : this.technicianName,
      date: date != null ? date() : this.date,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
    );
  }

  bool get hasAdvancedFilters =>
      (priority != null && priority!.isNotEmpty) ||
      typeId != null ||
      (typeName != null && typeName!.isNotEmpty) ||
      (costBearer != null && costBearer!.isNotEmpty) ||
      propertyId != null ||
      (propertyName != null && propertyName!.isNotEmpty) ||
      unitId != null ||
      technicianId != null ||
      (technicianName != null && technicianName!.isNotEmpty) ||
      (date != null && date!.isNotEmpty) ||
      sortBy != null;

  int get activeFiltersCount {
    int count = 0;
    if (status != null && status != 'all' && status!.isNotEmpty) count++;
    if (priority != null && priority!.isNotEmpty) count++;
    if (typeId != null || (typeName != null && typeName!.isNotEmpty)) count++;
    if (costBearer != null && costBearer!.isNotEmpty) count++;
    if (propertyId != null || (propertyName != null && propertyName!.isNotEmpty)) count++;
    if (unitId != null) count++;
    if (technicianId != null || (technicianName != null && technicianName!.isNotEmpty)) count++;
    if (date != null && date!.isNotEmpty) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    search,
    status,
    priority,
    typeId,
    typeName,
    costBearer,
    propertyId,
    propertyName,
    unitId,
    technicianId,
    technicianName,
    date,
    sortBy,
    sortAscending,
    page,
  ];
}
