import 'package:equatable/equatable.dart';

class CreateWarehouseItemParams extends Equatable {
  final String name;
  final String? sku;
  final String? serialNumber;
  final String category;
  final int warehouseId;
  final num quantity;
  final num minQuantity;
  final num unitPrice;
  final num sellingPrice;
  final String discountType;
  final num discountValue;
  final num taxPercentage;
  final bool priceIncludesTax;
  final String? description;
  final bool isActive;

  const CreateWarehouseItemParams({
    required this.name,
    this.sku,
    this.serialNumber,
    required this.category,
    required this.warehouseId,
    required this.quantity,
    required this.minQuantity,
    required this.unitPrice,
    required this.sellingPrice,
    required this.discountType,
    required this.discountValue,
    required this.taxPercentage,
    required this.priceIncludesTax,
    this.description,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (sku != null && sku!.isNotEmpty) 'sku': sku,
      if (serialNumber != null && serialNumber!.isNotEmpty)
        'serial_number': serialNumber,
      'category': category,
      'warehouse_id': warehouseId,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'unit_price': unitPrice,
      'selling_price': sellingPrice,
      'discount_type': discountType,
      'discount_value': discountValue,
      'tax_percentage': taxPercentage,
      'price_includes_tax': priceIncludesTax,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [
    name,
    sku,
    serialNumber,
    category,
    warehouseId,
    quantity,
    minQuantity,
    unitPrice,
    sellingPrice,
    discountType,
    discountValue,
    taxPercentage,
    priceIncludesTax,
    description,
    isActive,
  ];
}
