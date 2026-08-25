import '../../domain/entities/update_warehouse_item_params.dart';

class UpdateWarehouseItemParamsModel extends UpdateWarehouseItemParams {
  const UpdateWarehouseItemParamsModel({
    required super.id,
    super.minQuantity,
    super.sellingPrice,
    super.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (minQuantity != null) data['min_quantity'] = minQuantity;
    if (sellingPrice != null) data['selling_price'] = sellingPrice;
    if (description != null) data['description'] = description;
    return data;
  }
}
