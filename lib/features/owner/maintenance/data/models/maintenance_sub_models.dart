import '../../domain/entities/maintenance_sub_entities.dart';

int? _parseIntOrMap(dynamic value) {
  if (value is int) return value;
  if (value is Map<String, dynamic> && value['id'] is int) {
    return value['id'] as int;
  }
  if (value is String) return int.tryParse(value);
  return null;
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

class MaintenancePropertyRefModel2 extends MaintenancePropertyRefEntity {
  const MaintenancePropertyRefModel2({
    super.id,
    super.name,
    super.code,
    super.city,
    super.district,
  });

  factory MaintenancePropertyRefModel2.fromJson(Map<String, dynamic> json) {
    return MaintenancePropertyRefModel2(
      id: _parseIntOrMap(json['id']),
      name: json['name'] as String?,
      code: json['code'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
    );
  }
}

class MaintenanceUnitRefModel extends MaintenanceUnitRefEntity {
  const MaintenanceUnitRefModel({
    super.id,
    super.name,
    super.unitNumber,
    super.code,
  });

  factory MaintenanceUnitRefModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceUnitRefModel(
      id: _parseIntOrMap(json['id']),
      name: json['name'] as String?,
      unitNumber: json['unit_number'] as String?,
      code: json['code'] as String?,
    );
  }
}

class MaintenanceTypeModel extends MaintenanceTypeEntity {
  const MaintenanceTypeModel({
    super.id,
    super.name,
    super.nameAr,
    super.isActive,
  });

  factory MaintenanceTypeModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTypeModel(
      id: _parseIntOrMap(json['id']),
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }
}

class MaintenanceDatesModel extends MaintenanceDatesEntity {
  const MaintenanceDatesModel({
    super.requestedDate,
    super.scheduledDate,
    super.completedDate,
    super.qaConfirmedAt,
    super.createdAt,
    super.updatedAt,
  });

  factory MaintenanceDatesModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceDatesModel(
      requestedDate: json['requested_date'] as String?,
      scheduledDate: json['scheduled_date'] as String?,
      completedDate: json['completed_date'] as String?,
      qaConfirmedAt: json['qa_confirmed_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class MaintenanceStatsModel extends MaintenanceStatsEntity {
  const MaintenanceStatsModel({super.total, super.byStatus});

  factory MaintenanceStatsModel.fromJson(Map<String, dynamic> json) {
    final byStatusMap = json['by_status'] as Map<String, dynamic>?;
    final Map<String, int>? mappedByStatus = byStatusMap?.map(
      (key, value) => MapEntry(key, value as int),
    );

    return MaintenanceStatsModel(
      total: _parseIntOrMap(json['total']),
      byStatus: mappedByStatus,
    );
  }
}
