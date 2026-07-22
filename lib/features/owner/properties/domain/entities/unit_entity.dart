import 'package:equatable/equatable.dart';

class UnitEntity extends Equatable {
  final int id;
  final int propertyId;
  final String unitNumber;
  final String? floor;
  final num? area;
  final String? type;
  final String status;
  final num rentPrice;
  final num? deposit;
  final String? specs;
  final String? createdAt;

  const UnitEntity({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    this.floor,
    this.area,
    this.type,
    required this.status,
    required this.rentPrice,
    this.deposit,
    this.specs,
    this.createdAt,
  });

  bool get isVacant => status.toLowerCase() == 'vacant';
  bool get isOccupied => status.toLowerCase() == 'occupied' || status.toLowerCase() == 'rented';
  bool get isReserved => status.toLowerCase() == 'reserved';
  bool get isMaintenance => status.toLowerCase() == 'under_maintenance' || status.toLowerCase() == 'maintenance';

  @override
  List<Object?> get props => [
        id,
        propertyId,
        unitNumber,
        floor,
        area,
        type,
        status,
        rentPrice,
        deposit,
        specs,
        createdAt,
      ];
}
