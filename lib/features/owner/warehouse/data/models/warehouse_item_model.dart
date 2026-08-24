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
    super.lastCost = 0,
    super.finalSellingPrice = 0,
    required super.status,
    required super.statusLabel,
    super.imageUrl,
    super.description,
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
      quantityAvailable: json['quantity'] ?? json['quantity_available'] ?? 0,
      quantityMinLimit: json['min_quantity'] ?? json['quantity_min_limit'] ?? 0,
      lastCost: json['last_cost'] ?? 0,
      finalSellingPrice: json['pricing']?['final_selling_price'] ?? 0,
      status: json['stock_status'] ?? json['status'] ?? '',
      statusLabel: json['stock_status_label'] ?? json['status_label'] ?? '',
      imageUrl: json['image_url'],
      description: json['description'],
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
