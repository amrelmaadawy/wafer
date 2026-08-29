import 'package:equatable/equatable.dart';
import 'warehouse_entity.dart';

class WarehouseListResponseEntity extends Equatable {
  final List<WarehouseEntity> warehouses;

  const WarehouseListResponseEntity({
    required this.warehouses,
  });

  @override
  List<Object> get props => [warehouses];
}
