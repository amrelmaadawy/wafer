import 'package:equatable/equatable.dart';

class OccupancyPropertyEntity extends Equatable {
  final int propertyId;
  final String propertyName;
  final String code;
  final int totalUnits;
  final int rentedUnits;
  final int vacantUnits;
  final double occupancyRate;

  const OccupancyPropertyEntity({
    required this.propertyId,
    required this.propertyName,
    required this.code,
    required this.totalUnits,
    required this.rentedUnits,
    required this.vacantUnits,
    required this.occupancyRate,
  });

  @override
  List<Object?> get props => [
        propertyId,
        propertyName,
        code,
        totalUnits,
        rentedUnits,
        vacantUnits,
        occupancyRate,
      ];
}
