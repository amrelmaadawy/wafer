import 'package:equatable/equatable.dart';

class MaintenanceEntity extends Equatable {
  final int id;
  final String requestNumber;
  final String description;
  final String status;
  final String statusLabel;
  final num estimatedCost;
  final num actualCost;
  final String? requestedDate;
  final int? propertyId;
  final String? propertyName;
  final int? unitId;
  final String unitName;
  final int? tenantId;
  final String? tenantName;
  final int? contractId;

  const MaintenanceEntity({
    required this.id,
    required this.requestNumber,
    required this.description,
    required this.status,
    required this.statusLabel,
    this.estimatedCost = 0,
    this.actualCost = 0,
    this.requestedDate,
    this.propertyId,
    this.propertyName,
    this.unitId,
    required this.unitName,
    this.tenantId,
    this.tenantName,
    this.contractId,
  });

  @override
  List<Object?> get props => [
    id,
    requestNumber,
    description,
    status,
    statusLabel,
    estimatedCost,
    actualCost,
    requestedDate,
    propertyId,
    propertyName,
    unitId,
    unitName,
    tenantId,
    tenantName,
    contractId,
  ];
}
