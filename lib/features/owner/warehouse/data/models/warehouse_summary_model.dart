import '../../domain/entities/warehouse_summary_entity.dart';
import 'warehouse_item_model.dart';
import 'warehouse_movement_model.dart';
import 'warehouse_stats_model.dart';

class WarehouseSummaryModel extends WarehouseSummaryEntity {
  const WarehouseSummaryModel({
    required super.stats,
    required super.lowStockItems,
    required super.recentMovements,
  });

  factory WarehouseSummaryModel.fromJson(Map<String, dynamic> json) {
    return WarehouseSummaryModel(
      stats: json['stats'] != null
          ? WarehouseStatsModel.fromJson(json['stats'])
          : const WarehouseStatsModel(
              totalItems: 0,
              activeItems: 0,
              lowItems: 0,
              outItems: 0,
              warehousesCount: 0,
              suppliersCount: 0,
              inventoryValue: 0,
            ),
      lowStockItems: json['low_stock_items'] != null
          ? List<WarehouseItemModel>.from(
              (json['low_stock_items'] as List).map(
                (e) => WarehouseItemModel.fromJson(e),
              ),
            )
          : [],
      recentMovements: json['recent_movements'] != null
          ? List<WarehouseMovementModel>.from(
              (json['recent_movements'] as List).map(
                (e) => WarehouseMovementModel.fromJson(e),
              ),
            )
          : [],
    );
  }
}
