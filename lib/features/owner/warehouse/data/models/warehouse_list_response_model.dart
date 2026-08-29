import '../../domain/entities/warehouse_list_response_entity.dart';
import 'warehouse_model.dart';

class WarehouseListResponseModel extends WarehouseListResponseEntity {
  const WarehouseListResponseModel({
    required super.warehouses,
  });

  factory WarehouseListResponseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseListResponseModel(
      warehouses: (json['warehouses'] as List<dynamic>?)
              ?.map((e) => WarehouseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouses':
          warehouses.map((e) => (e as WarehouseModel).toJson()).toList(),
    };
  }
}
