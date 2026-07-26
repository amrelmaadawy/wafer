import 'package:equatable/equatable.dart';
import 'units_status_property_entity.dart';

class UnitsStatusItemEntity extends Equatable {
  final int id;
  final String unitNumber;
  final String name;
  final String code;
  final UnitsStatusPropertyEntity property;
  final int? floorNumber;
  final String status;
  final String statusLabel;
  final dynamic activeContract; // Can be parsed later if needed, mostly null here
  final String createdAt;

  const UnitsStatusItemEntity({
    required this.id,
    required this.unitNumber,
    required this.name,
    required this.code,
    required this.property,
    this.floorNumber,
    required this.status,
    required this.statusLabel,
    this.activeContract,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        unitNumber,
        name,
        code,
        property,
        floorNumber,
        status,
        statusLabel,
        activeContract,
        createdAt,
      ];
}
