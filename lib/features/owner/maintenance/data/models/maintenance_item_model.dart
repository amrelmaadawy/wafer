import '../../domain/entities/maintenance_item_entity.dart';
import 'maintenance_complex_sub_models.dart';
import 'maintenance_sub_models.dart';

class MaintenanceItemModel extends MaintenanceItemEntity {
  const MaintenanceItemModel({
    super.id,
    super.requestNumber,
    super.title,
    super.description,
    super.customType,
    super.client,
    super.status,
    super.statusLabel,
    super.costBearer,
    super.costBearerLabel,
    super.isPrivate,
    super.financials,
    super.property,
    super.unit,
    super.types,
    super.people,
    super.supervisorNotes,
    super.dates,
    super.qa,
    super.rating,
    super.images,
    super.assignments,
    super.tasks,
    super.actionLogs,
  });

  factory MaintenanceItemModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceItemModel(
      id: json['id'] as int?,
      requestNumber: json['request_number'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      customType: json['custom_type'] as String?,
      client: json['client'] != null
          ? MaintenanceClientModel.fromJson(json['client'])
          : null,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      costBearer: json['cost_bearer'] as String?,
      costBearerLabel: json['cost_bearer_label'] as String?,
      isPrivate: json['is_private'] as bool?,
      financials: json['financials'] != null
          ? MaintenanceFinancialsModel.fromJson(json['financials'])
          : null,
      property: json['property'] != null
          ? MaintenancePropertyRefModel2.fromJson(json['property'])
          : null,
      unit: json['unit'] != null
          ? MaintenanceUnitRefModel.fromJson(json['unit'])
          : null,
      types: json['types'] != null
          ? (json['types'] as List)
                .map((e) => MaintenanceTypeModel.fromJson(e))
                .toList()
          : null,
      people: json['people'] != null
          ? MaintenancePeopleModel.fromJson(json['people'])
          : null,
      supervisorNotes: json['supervisor_notes'] as String?,
      dates: json['dates'] != null
          ? MaintenanceDatesModel.fromJson(json['dates'])
          : null,
      qa: json['qa'] != null ? MaintenanceQaModel.fromJson(json['qa']) : null,
      rating: json['rating'] != null
          ? MaintenanceRatingModel.fromJson(json['rating'])
          : null,
      images: json['images'] != null
          ? (json['images'] as List).map((e) => e.toString()).toList()
          : null,
      assignments: json['assignments'] != null
          ? (json['assignments'] as List)
                .map((e) => MaintenanceAssignmentModel.fromJson(e))
                .toList()
          : null,
      tasks: json['tasks'] != null
          ? (json['tasks'] as List)
                .map((e) => MaintenanceTaskModel.fromJson(e))
                .toList()
          : null,
      actionLogs: json['action_logs'] != null
          ? (json['action_logs'] as List)
                .map((e) => MaintenanceActionLogModel.fromJson(e))
                .toList()
          : null,
    );
  }
}
