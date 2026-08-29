import '../../domain/entities/warehouse_entity.dart';

class WarehouseParentModel extends WarehouseParentEntity {
  const WarehouseParentModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory WarehouseParentModel.fromJson(Map<String, dynamic> json) {
    return WarehouseParentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.code,
    super.parent,
    required super.isMain,
    required super.isActive,
    required super.statusLabel,
    required super.itemsCount,
    required super.movementsCount,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      parent: json['parent'] != null
          ? WarehouseParentModel.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      isMain: json['is_main'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      statusLabel: json['status_label'] as String? ?? '',
      itemsCount: json['items_count'] as int? ?? 0,
      movementsCount: json['movements_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'parent': parent != null
          ? {
              'id': parent!.id,
              'name': parent!.name,
              'code': parent!.code,
            }
          : null,
      'is_main': isMain,
      'is_active': isActive,
      'status_label': statusLabel,
      'items_count': itemsCount,
      'movements_count': movementsCount,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
