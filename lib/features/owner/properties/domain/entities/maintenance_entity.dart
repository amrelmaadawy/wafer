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
  final String unitName;

  const MaintenanceEntity({
    required this.id,
    required this.requestNumber,
    required this.description,
    required this.status,
    required this.statusLabel,
    this.estimatedCost = 0,
    this.actualCost = 0,
    this.requestedDate,
    required this.unitName,
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
    unitName,
  ];
}
