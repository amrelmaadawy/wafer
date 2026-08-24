import 'package:equatable/equatable.dart';

class WarehouseStatsEntity extends Equatable {
  final int totalItems;
  final int activeItems;
  final int lowItems;
  final int outItems;
  final int warehousesCount;
  final int suppliersCount;
  final num inventoryValue;

  const WarehouseStatsEntity({
    required this.totalItems,
    required this.activeItems,
    required this.lowItems,
    required this.outItems,
    required this.warehousesCount,
    required this.suppliersCount,
    required this.inventoryValue,
  });

  @override
  List<Object?> get props => [
        totalItems,
        activeItems,
        lowItems,
        outItems,
        warehousesCount,
        suppliersCount,
        inventoryValue,
      ];
}
