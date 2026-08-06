import '../../domain/entities/maintenance_requests_list_entity.dart';

int _parseIntOrMap(dynamic value) {
  if (value is int) return value;
  if (value is Map<String, dynamic> && value['id'] is int) {
    return value['id'] as int;
  }
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class MaintenanceRequestsListResponseModel
    extends MaintenanceRequestsListResponseEntity {
  const MaintenanceRequestsListResponseModel({
    required super.maintenanceRequests,
  });

  factory MaintenanceRequestsListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaintenanceRequestsListResponseModel(
      maintenanceRequests:
          (json['maintenance_requests'] as List?)
              ?.map((e) => MaintenanceRequestListItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MaintenanceRequestListItemModel extends MaintenanceRequestListItemEntity {
  const MaintenanceRequestListItemModel({
    required super.id,
    super.requestNumber,
    super.title,
    super.description,
    super.customType,
    super.client,
    super.status,
    super.statusLabel,
    super.costBearer,
    super.costBearerLabel,
    required super.isPrivate,
    super.financials,
  });

  factory MaintenanceRequestListItemModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestListItemModel(
      id: _parseIntOrMap(json['id']),
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
      isPrivate: json['is_private'] as bool? ?? false,
      financials: json['financials'] != null
          ? MaintenanceFinancialsModel.fromJson(json['financials'])
          : null,
    );
  }
}

class MaintenanceClientModel extends MaintenanceClientEntity {
  const MaintenanceClientModel({super.name, super.phone});

  factory MaintenanceClientModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceClientModel(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class MaintenanceFinancialsModel extends MaintenanceFinancialsEntity {
  const MaintenanceFinancialsModel({
    super.estimatedCost,
    super.advancePayment,
    super.actualCost,
  });

  factory MaintenanceFinancialsModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFinancialsModel(
      estimatedCost: json['estimated_cost'] as num?,
      advancePayment: json['advance_payment'] as num?,
      actualCost: json['actual_cost'] as num?,
    );
  }
}
