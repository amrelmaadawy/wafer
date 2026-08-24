import 'package:equatable/equatable.dart';
import 'warehouse_item_entity.dart';
import 'warehouse_pagination_entity.dart';

class WarehouseItemsResponseEntity extends Equatable {
  final List<WarehouseItemEntity> items;
  final WarehousePaginationEntity pagination;

  const WarehouseItemsResponseEntity({
    required this.items,
    required this.pagination,
  });

  @override
  List<Object?> get props => [items, pagination];
}
