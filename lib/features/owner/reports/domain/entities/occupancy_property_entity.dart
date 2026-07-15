import 'package:equatable/equatable.dart';

class OccupancyPropertyEntity extends Equatable {
  final int propertyId;
  final String propertyName;
  final int totalUnits;
  final int rentedUnits;
  final int vacantUnits;
  final double occupancyRate;

  const OccupancyPropertyEntity({
    required this.propertyId,
    required this.propertyName,
    required this.totalUnits,
    required this.rentedUnits,
    required this.vacantUnits,
    required this.occupancyRate,
  });

  @override
  List<Object?> get props => [
        propertyId,
        propertyName,
        totalUnits,
        rentedUnits,
        vacantUnits,
        occupancyRate,
      ];
}
