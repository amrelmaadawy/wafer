import 'package:equatable/equatable.dart';

import 'warehouse_item_entity.dart';

class WarehouseMovementEntity extends Equatable {
  final int id;
  final String date;
  final String type;
  final String typeLabel;
  final WarehouseItemEntity item;
  final num quantity;
  final num quantityBefore;
  final num quantityAfter;
  final num unitCost;
  final num totalCost;
  final String referenceType;
  final int? referenceId;

  const WarehouseMovementEntity({
    required this.id,
    required this.date,
    required this.type,
    required this.typeLabel,
    required this.item,
    required this.quantity,
    required this.quantityBefore,
    required this.quantityAfter,
    required this.unitCost,
    required this.totalCost,
    required this.referenceType,
    this.referenceId,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        type,
        typeLabel,
        item,
        quantity,
        quantityBefore,
        quantityAfter,
        unitCost,
        totalCost,
        referenceType,
        referenceId,
      ];
}
