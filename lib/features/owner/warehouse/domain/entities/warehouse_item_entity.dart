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
  final String status;
  final String statusLabel;

  const WarehouseItemEntity({
    required this.id,
    required this.name,
    this.sku,
    this.serialNumber,
    required this.category,
    required this.warehouse,
    required this.quantityAvailable,
    required this.quantityMinLimit,
    required this.lastCost,
    required this.status,
    required this.statusLabel,
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
        status,
        statusLabel,
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
