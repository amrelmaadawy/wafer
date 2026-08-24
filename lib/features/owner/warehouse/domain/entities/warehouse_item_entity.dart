import 'package:equatable/equatable.dart';

class WarehouseItemEntity extends Equatable {
  final int id;
  final String name;
  final String? sku;
  final String? serialNumber;
  final String category;
  final WarehouseEntity warehouse;
  final num quantityAvailable;
  final num quantityMinLimit;
  final num lastCost;
  final num finalSellingPrice;
  final String status;
  final String statusLabel;
  final String? imageUrl;
  final String? description;

  const WarehouseItemEntity({
    required this.id,
    required this.name,
    this.sku,
    this.serialNumber,
    required this.category,
    required this.warehouse,
    required this.quantityAvailable,
    required this.quantityMinLimit,
    this.lastCost = 0,
    this.finalSellingPrice = 0,
    required this.status,
    required this.statusLabel,
    this.imageUrl,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        serialNumber,
        category,
        warehouse,
        quantityAvailable,
        quantityMinLimit,
        lastCost,
        finalSellingPrice,
        status,
        statusLabel,
        imageUrl,
        description,
      ];
}

class WarehouseEntity extends Equatable {
  final int id;
  final String name;
  final String branchName;

  const WarehouseEntity({
    required this.id,
    required this.name,
    required this.branchName,
  });

  @override
  List<Object?> get props => [id, name, branchName];
}
