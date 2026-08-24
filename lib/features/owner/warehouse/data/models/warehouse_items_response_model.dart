import '../../domain/entities/warehouse_items_response_entity.dart';
import 'warehouse_item_model.dart';
import 'warehouse_pagination_model.dart';

class WarehouseItemsResponseModel extends WarehouseItemsResponseEntity {
  const WarehouseItemsResponseModel({
    required super.items,
    required super.pagination,
  });

  factory WarehouseItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemsResponseModel(
      items: (json['items'] as List?)
              ?.map((item) => WarehouseItemModel.fromJson(item))
              .toList() ??
          [],
      pagination: WarehousePaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
