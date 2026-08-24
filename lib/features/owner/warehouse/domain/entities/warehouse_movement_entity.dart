import 'package:equatable/equatable.dart';

import 'warehouse_item_entity.dart';

class WarehouseMovementEntity extends Equatable {
  final int id;
  final String date;
  final String type;
  final String typeLabel;
  final WarehouseItemEntity item;
  final num quantity;
  final num quantityBefore;
  final num quantityAfter;
  final num unitCost;
  final num totalCost;
  final String referenceType;
  final int? referenceId;
  final String? referenceNumber;
  final String? reason;
  final String? reasonLabel;
  final String? notes;
  final String? createdByName;
  final String? journalEntryNumber;
  final String? journalEntryStatus;
  final String? createdAt;

  const WarehouseMovementEntity({
    required this.id,
    required this.date,
    required this.type,
    required this.typeLabel,
    required this.item,
    required this.quantity,
    required this.quantityBefore,
    required this.quantityAfter,
    required this.unitCost,
    required this.totalCost,
    required this.referenceType,
    this.referenceId,
    this.referenceNumber,
    this.reason,
    this.reasonLabel,
    this.notes,
    this.createdByName,
    this.journalEntryNumber,
    this.journalEntryStatus,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    type,
    typeLabel,
    item,
    quantity,
    quantityBefore,
    quantityAfter,
    unitCost,
    totalCost,
    referenceType,
    referenceId,
    referenceNumber,
    reason,
    reasonLabel,
    notes,
    createdByName,
    journalEntryNumber,
    journalEntryStatus,
    createdAt,
  ];
}
