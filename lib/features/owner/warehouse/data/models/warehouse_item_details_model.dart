import '../../domain/entities/warehouse_item_details_entity.dart';
import 'warehouse_item_model.dart';
import 'warehouse_movement_model.dart';

class WarehouseItemPricingModel extends WarehouseItemPricingEntity {
  const WarehouseItemPricingModel({
    required super.unitPrice,
    required super.sellingPrice,
    required super.discountType,
    required super.discountTypeLabel,
    required super.discountValue,
    required super.taxPercentage,
    required super.priceIncludesTax,
    required super.priceIncludesTaxLabel,
    required super.discountAmount,
    required super.netSellingPrice,
    required super.taxAmount,
    required super.finalSellingPrice,
    required super.inventoryValue,
  });

  factory WarehouseItemPricingModel.fromJson(Map<String, dynamic> json) {
    return WarehouseItemPricingModel(
      unitPrice: json['unit_price'] ?? 0,
      sellingPrice: json['selling_price'] ?? 0,
      discountType: json['discount_type'] ?? '',
      discountTypeLabel: json['discount_type_label'] ?? '',
      discountValue: json['discount_value'] ?? 0,
      taxPercentage: json['tax_percentage'] ?? 0,
      priceIncludesTax: json['price_includes_tax'] ?? false,
      priceIncludesTaxLabel: json['price_includes_tax_label'] ?? '',
      discountAmount: json['discount_amount'] ?? 0,
      netSellingPrice: json['net_selling_price'] ?? 0,
      taxAmount: json['tax_amount'] ?? 0,
      finalSellingPrice: json['final_selling_price'] ?? 0,
      inventoryValue: json['inventory_value'] ?? 0,
    );
  }
}

class WarehouseItemDetailsModel extends WarehouseItemDetailsEntity {
  WarehouseItemDetailsModel({
    required super.id,
    required super.name,
    super.sku,
    super.serialNumber,
    required super.category,
    required super.warehouse,
    required super.quantityAvailable,
    required super.quantityMinLimit,
    required super.status,
    required super.statusLabel,
    super.imageUrl,
    super.description,
    required super.pricing,
    required super.movementsCount,
    required super.recentMovements,
    super.createdAt,
    super.updatedAt,
  });

  factory WarehouseItemDetailsModel.fromJson(Map<String, dynamic> json) {
    final pricingJson = json['pricing'] as Map<String, dynamic>? ?? {};
    final movementsJson = json['recent_movements'] as List<dynamic>? ?? [];

    return WarehouseItemDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sku: json['sku'],
      serialNumber: json['serial_number'],
      category: json['category'] ?? '',
      warehouse: json['warehouse'] != null
          ? WarehouseModel.fromJson(json['warehouse'])
          : const WarehouseModel(id: 0, name: '', branchName: ''),
      quantityAvailable: json['quantity'] ?? json['quantity_available'] ?? 0,
      quantityMinLimit: json['min_quantity'] ?? json['quantity_min_limit'] ?? 0,
      status: json['stock_status'] ?? json['status'] ?? '',
      statusLabel: json['stock_status_label'] ?? json['status_label'] ?? '',
      imageUrl: json['image_url'],
      description: json['description'],
      pricing: WarehouseItemPricingModel.fromJson(pricingJson),
      movementsCount: json['movements_count'] ?? 0,
      recentMovements: movementsJson
          .map((m) => WarehouseMovementModel.fromJson(m))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
