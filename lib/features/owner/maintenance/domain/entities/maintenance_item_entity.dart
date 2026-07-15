import 'package:equatable/equatable.dart';
import 'maintenance_property_ref_entity.dart';

class MaintenanceItemEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String status;
  final String statusLabel;
  final String costBearer;
  final String costBearerLabel;
  final double estimatedCost;
  final double actualCost;
  final double advancePayment;
  final MaintenancePropertyRefEntity property;
  final MaintenancePropertyRefEntity unit;
  final String requestedDate;
  final String? scheduledDate;
  final String? completedDate;
  final List<String> images;

  const MaintenanceItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.costBearer,
    required this.costBearerLabel,
    required this.estimatedCost,
    required this.actualCost,
    required this.advancePayment,
    required this.property,
    required this.unit,
    required this.requestedDate,
    this.scheduledDate,
    this.completedDate,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        statusLabel,
        costBearer,
        costBearerLabel,
        estimatedCost,
        actualCost,
        advancePayment,
        property,
        unit,
        requestedDate,
        scheduledDate,
        completedDate,
        images,
      ];
}
