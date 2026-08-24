import 'package:equatable/equatable.dart';

import 'warehouse_item_entity.dart';
import 'warehouse_movement_entity.dart';
import 'warehouse_stats_entity.dart';

class WarehouseSummaryEntity extends Equatable {
  final WarehouseStatsEntity stats;
  final List<WarehouseItemEntity> lowStockItems;
  final List<WarehouseMovementEntity> recentMovements;

  const WarehouseSummaryEntity({
    required this.stats,
    required this.lowStockItems,
    required this.recentMovements,
  });

  @override
  List<Object?> get props => [stats, lowStockItems, recentMovements];
}
