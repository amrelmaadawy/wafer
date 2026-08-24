import '../../domain/entities/warehouse_stats_entity.dart';

class WarehouseStatsModel extends WarehouseStatsEntity {
  const WarehouseStatsModel({
    required super.totalItems,
    required super.activeItems,
    required super.lowItems,
    required super.outItems,
    required super.warehousesCount,
    required super.suppliersCount,
    required super.inventoryValue,
  });

  factory WarehouseStatsModel.fromJson(Map<String, dynamic> json) {
    return WarehouseStatsModel(
      totalItems: json['total_items'] ?? 0,
      activeItems: json['active_items'] ?? 0,
      lowItems: json['low_items'] ?? 0,
      outItems: json['out_items'] ?? 0,
      warehousesCount: json['warehouses_count'] ?? 0,
      suppliersCount: json['suppliers_count'] ?? 0,
      inventoryValue: json['inventory_value'] ?? 0,
    );
  }
}
