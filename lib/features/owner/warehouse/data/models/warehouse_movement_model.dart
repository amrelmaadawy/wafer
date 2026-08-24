import '../../domain/entities/warehouse_movement_entity.dart';
import 'warehouse_item_model.dart';

class WarehouseMovementModel extends WarehouseMovementEntity {
  const WarehouseMovementModel({
    required super.id,
    required super.date,
    required super.type,
    required super.typeLabel,
    required super.item,
    required super.quantity,
    required super.quantityBefore,
    required super.quantityAfter,
    required super.unitCost,
    required super.totalCost,
    required super.referenceType,
    super.referenceId,
  });

  factory WarehouseMovementModel.fromJson(Map<String, dynamic> json) {
    return WarehouseMovementModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      typeLabel: json['type_label'] ?? '',
      item: json['item'] != null
          ? WarehouseItemModel.fromJson(json['item'])
          : const WarehouseItemModel(
              id: 0,
              name: '',
              category: '',
              warehouse: WarehouseModel(id: 0, name: '', branchName: ''),
              quantityAvailable: 0,
              quantityMinLimit: 0,
              lastCost: 0,
              status: '',
              statusLabel: '',
            ),
      quantity: json['quantity'] ?? 0,
      quantityBefore: json['quantity_before'] ?? 0,
      quantityAfter: json['quantity_after'] ?? 0,
      unitCost: json['unit_cost'] ?? 0,
      totalCost: json['total_cost'] ?? 0,
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'],
    );
  }
}
