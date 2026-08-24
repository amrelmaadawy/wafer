import '../../domain/entities/warehouse_item_entity.dart';

class WarehouseItemModel extends WarehouseItemEntity {
  const WarehouseItemModel({
    required super.id,
    required super.name,
    super.sku,
    super.serialNumber,
    required super.category,
    required super.warehouse,
    required super.quantityAvailable,
    required super.quantityMinLimit,
    required super.lastCost,
    required super.status,
    required super.statusLabel,
  });

  factory WarehouseItemModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sku: json['sku'],
      serialNumber: json['serial_number'],
      category: json['category'] ?? '',
      warehouse: json['warehouse'] != null
          ? WarehouseModel.fromJson(json['warehouse'])
          : const WarehouseModel(id: 0, name: '', branchName: ''),
      quantityAvailable: json['quantity_available'] ?? 0,
      quantityMinLimit: json['quantity_min_limit'] ?? 0,
      lastCost: json['last_cost'] ?? 0,
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
    );
  }
}

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.branchName,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      branchName: json['branch_name'] ?? '',
    );
  }
}
