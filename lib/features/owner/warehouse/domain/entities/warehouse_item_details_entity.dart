import 'package:equatable/equatable.dart';

import 'warehouse_item_entity.dart';
import 'warehouse_movement_entity.dart';

class WarehouseItemPricingEntity extends Equatable {
  final num unitPrice;
  final num sellingPrice;
  final String discountType;
  final String discountTypeLabel;
  final num discountValue;
  final num taxPercentage;
  final bool priceIncludesTax;
  final String priceIncludesTaxLabel;
  final num discountAmount;
  final num netSellingPrice;
  final num taxAmount;
  final num finalSellingPrice;
  final num inventoryValue;

  const WarehouseItemPricingEntity({
    required this.unitPrice,
    required this.sellingPrice,
    required this.discountType,
    required this.discountTypeLabel,
    required this.discountValue,
    required this.taxPercentage,
    required this.priceIncludesTax,
    required this.priceIncludesTaxLabel,
    required this.discountAmount,
    required this.netSellingPrice,
    required this.taxAmount,
    required this.finalSellingPrice,
    required this.inventoryValue,
  });

  @override
  List<Object?> get props => [
        unitPrice,
        sellingPrice,
        discountType,
        discountTypeLabel,
        discountValue,
        taxPercentage,
        priceIncludesTax,
        priceIncludesTaxLabel,
        discountAmount,
        netSellingPrice,
        taxAmount,
        finalSellingPrice,
        inventoryValue,
      ];
}

class WarehouseItemDetailsEntity extends WarehouseItemEntity {
  final WarehouseItemPricingEntity pricing;
  final int movementsCount;
  final List<WarehouseMovementEntity> recentMovements;
  final String? createdAt;
  final String? updatedAt;

  WarehouseItemDetailsEntity({
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
    required this.pricing,
    required this.movementsCount,
    required this.recentMovements,
    this.createdAt,
    this.updatedAt,
  }) : super(
          lastCost: pricing.unitPrice,
          finalSellingPrice: pricing.finalSellingPrice,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        pricing,
        movementsCount,
        recentMovements,
        createdAt,
        updatedAt,
      ];
}
