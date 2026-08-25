import 'package:equatable/equatable.dart';
import 'warehouse_item_details_entity.dart';

class WarehouseItemDeltaFieldEntity extends Equatable {
  final String before;
  final String after;
  final String label;

  const WarehouseItemDeltaFieldEntity({
    required this.before,
    required this.after,
    required this.label,
  });

  @override
  List<Object?> get props => [before, after, label];
}

class WarehouseItemDeltaEntity extends Equatable {
  final Map<String, WarehouseItemDeltaFieldEntity> changed;
  final int changedCount;
  final String description;

  const WarehouseItemDeltaEntity({
    required this.changed,
    required this.changedCount,
    required this.description,
  });

  @override
  List<Object?> get props => [changed, changedCount, description];
}

class WarehouseItemUpdateResultEntity extends Equatable {
  final WarehouseItemDetailsEntity item;
  final WarehouseItemDeltaEntity delta;

  const WarehouseItemUpdateResultEntity({
    required this.item,
    required this.delta,
  });

  @override
  List<Object?> get props => [item, delta];
}
