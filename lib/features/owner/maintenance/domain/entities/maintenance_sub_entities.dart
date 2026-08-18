import 'package:equatable/equatable.dart';

class MaintenanceClientEntity extends Equatable {
  final String? name;
  final String? phone;

  const MaintenanceClientEntity({this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class MaintenanceFinancialsEntity extends Equatable {
  final num? estimatedCost;
  final num? advancePayment;
  final num? actualCost;

  const MaintenanceFinancialsEntity({
    this.estimatedCost,
    this.advancePayment,
    this.actualCost,
  });

  @override
  List<Object?> get props => [estimatedCost, advancePayment, actualCost];
}

class MaintenancePropertyRefEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? city;
  final String? district;

  const MaintenancePropertyRefEntity({
    this.id,
    this.name,
    this.code,
    this.city,
    this.district,
  });

  @override
  List<Object?> get props => [id, name, code, city, district];
}

class MaintenanceUnitRefEntity extends Equatable {
  final int? id;
  final String? name;
  final String? unitNumber;
  final String? code;

  const MaintenanceUnitRefEntity({
    this.id,
    this.name,
    this.unitNumber,
    this.code,
  });

  @override
  List<Object?> get props => [id, name, unitNumber, code];
}

class MaintenanceTypeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? nameAr;
  final bool? isActive;

  const MaintenanceTypeEntity({this.id, this.name, this.nameAr, this.isActive});

  String getLocalizedName(String langCode) {
    if (langCode == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name ?? (id != null ? '$id' : '');
  }

  @override
  List<Object?> get props => [id, name, nameAr, isActive];
}

class MaintenanceStatusOptionEntity extends Equatable {
  final String value;
  final String label;

  const MaintenanceStatusOptionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class MaintenancePriorityOptionEntity extends Equatable {
  final String value;
  final String label;

  const MaintenancePriorityOptionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class MaintenanceCostBearerOptionEntity extends Equatable {
  final String value;
  final String label;

  const MaintenanceCostBearerOptionEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class MaintenanceDatesEntity extends Equatable {
  final String? requestedDate;
  final String? scheduledDate;
  final String? completedDate;
  final String? qaConfirmedAt;
  final String? createdAt;
  final String? updatedAt;

  const MaintenanceDatesEntity({
    this.requestedDate,
    this.scheduledDate,
    this.completedDate,
    this.qaConfirmedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    requestedDate,
    scheduledDate,
    completedDate,
    qaConfirmedAt,
    createdAt,
    updatedAt,
  ];
}

class MaintenanceStatsEntity extends Equatable {
  final int? total;
  final Map<String, int>? byStatus;

  const MaintenanceStatsEntity({this.total, this.byStatus});

  @override
  List<Object?> get props => [total, byStatus];
}
