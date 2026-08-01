import 'package:equatable/equatable.dart';

import 'maintenance_complex_sub_entities.dart';
import 'maintenance_sub_entities.dart';

class MaintenanceItemEntity extends Equatable {
  final int? id;
  int get safeId => id ?? 0;
  final String? requestNumber;
  final String? title;
  final String? description;
  final String? customType;
  final MaintenanceClientEntity? client;
  final String? status;
  final String? statusLabel;
  final String? costBearer;
  final String? costBearerLabel;
  final bool? isPrivate;
  final MaintenanceFinancialsEntity? financials;
  final MaintenancePropertyRefEntity? property;
  final MaintenanceUnitRefEntity? unit;
  final List<MaintenanceTypeEntity>? types;
  final MaintenancePeopleEntity? people;
  final String? supervisorNotes;
  final MaintenanceDatesEntity? dates;
  final MaintenanceQaEntity? qa;
  final MaintenanceRatingEntity? rating;
  final List<String>? images;
  final List<MaintenanceAssignmentEntity>? assignments;
  final List<MaintenanceTaskEntity>? tasks;
  final List<MaintenanceActionLogEntity>? actionLogs;

  const MaintenanceItemEntity({
    this.id,
    this.requestNumber,
    this.title,
    this.description,
    this.customType,
    this.client,
    this.status,
    this.statusLabel,
    this.costBearer,
    this.costBearerLabel,
    this.isPrivate,
    this.financials,
    this.property,
    this.unit,
    this.types,
    this.people,
    this.supervisorNotes,
    this.dates,
    this.qa,
    this.rating,
    this.images,
    this.assignments,
    this.tasks,
    this.actionLogs,
  });

  @override
  List<Object?> get props => [
    id,
    requestNumber,
    title,
    description,
    customType,
    client,
    status,
    statusLabel,
    costBearer,
    costBearerLabel,
    isPrivate,
    financials,
    property,
    unit,
    types,
    people,
    supervisorNotes,
    dates,
    qa,
    rating,
    images,
    assignments,
    tasks,
    actionLogs,
  ];
}
