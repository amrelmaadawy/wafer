import '../../domain/entities/warehouse_item_update_result_entity.dart';
import 'warehouse_item_details_model.dart';

class WarehouseItemDeltaFieldModel extends WarehouseItemDeltaFieldEntity {
  const WarehouseItemDeltaFieldModel({
    required super.before,
    required super.after,
    required super.label,
  });

  factory WarehouseItemDeltaFieldModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemDeltaFieldModel(
      before: json['before']?.toString() ?? '',
      after: json['after']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class WarehouseItemDeltaModel extends WarehouseItemDeltaEntity {
  const WarehouseItemDeltaModel({
    required super.changed,
    required super.changedCount,
    required super.description,
  });

  factory WarehouseItemDeltaModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> changedMap = {};
    if (json['changed'] is Map) {
      changedMap = Map<String, dynamic>.from(json['changed']);
    }
    
    final changedFields = <String, WarehouseItemDeltaFieldModel>{};
    
    changedMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        changedFields[key] = WarehouseItemDeltaFieldModel.fromJson(value);
      }
    });

    return WarehouseItemDeltaModel(
      changed: changedFields,
      changedCount: json['changed_count'] ?? 0,
      description: json['description']?.toString() ?? '',
    );
  }
}

class WarehouseItemUpdateResultModel extends WarehouseItemUpdateResultEntity {
  const WarehouseItemUpdateResultModel({
    required super.item,
    required super.delta,
  });

  factory WarehouseItemUpdateResultModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemUpdateResultModel(
      item: WarehouseItemDetailsModel.fromJson(json['item']),
      delta: WarehouseItemDeltaModel.fromJson(json['delta'] ?? {}),
    );
  }
}
