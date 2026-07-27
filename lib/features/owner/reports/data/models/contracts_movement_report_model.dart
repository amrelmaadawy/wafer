import '../../domain/entities/contracts_movement_report_entity.dart';
import '../../domain/entities/contracts_movement_summary_entity.dart';
import '../../domain/entities/contracts_movement_item_entity.dart';

class ContractsMovementReportModel extends ContractsMovementReportEntity {
  const ContractsMovementReportModel({
    required super.summary,
    required super.items,
    required super.pagination,
  });

  factory ContractsMovementReportModel.fromJson(Map<String, dynamic> json) {
    return ContractsMovementReportModel(
      summary: ContractsMovementSummaryModel.fromJson(json['summary'] ?? {}),
      items: (json['items'] as List?)
              ?.map((e) => ContractsMovementItemModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ContractsMovementSummaryModel extends ContractsMovementSummaryEntity {
  const ContractsMovementSummaryModel({
    required super.totalMovements,
    required super.creations,
    required super.renewals,
    required super.terminations,
  });

  factory ContractsMovementSummaryModel.fromJson(Map<String, dynamic> json) {
    return ContractsMovementSummaryModel(
      totalMovements: (json['total_movements'] as num?)?.toInt() ?? 0,
      creations: (json['creations'] as num?)?.toInt() ?? 0,
      renewals: (json['renewals'] as num?)?.toInt() ?? 0,
      terminations: (json['terminations'] as num?)?.toInt() ?? 0,
    );
  }
}

class ContractsMovementItemModel extends ContractsMovementItemEntity {
  const ContractsMovementItemModel({
    required super.contractNumber,
    required super.renter,
    required super.property,
    required super.unit,
    required super.date,
    required super.type,
    required super.rentValue,
    required super.status,
    required super.statusLabel,
  });

  factory ContractsMovementItemModel.fromJson(Map<String, dynamic> json) {
    return ContractsMovementItemModel(
      contractNumber: json['contract_number']?.toString() ?? '',
      renter: MovementRenterModel.fromJson(json['renter'] ?? {}),
      property: MovementPropertyModel.fromJson(json['property'] ?? {}),
      unit: MovementUnitModel.fromJson(json['unit'] ?? {}),
      date: json['date']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      rentValue: (json['rent_value'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }
}

class MovementRenterModel extends MovementRenterEntity {
  const MovementRenterModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.userType,
  });

  factory MovementRenterModel.fromJson(Map<String, dynamic> json) {
    return MovementRenterModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? '',
    );
  }
}

class MovementPropertyModel extends MovementPropertyEntity {
  const MovementPropertyModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory MovementPropertyModel.fromJson(Map<String, dynamic> json) {
    return MovementPropertyModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

class MovementUnitModel extends MovementUnitEntity {
  const MovementUnitModel({
    required super.id,
    required super.name,
    required super.unitNumber,
    required super.status,
    required super.statusLabel,
  });

  factory MovementUnitModel.fromJson(Map<String, dynamic> json) {
    return MovementUnitModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
