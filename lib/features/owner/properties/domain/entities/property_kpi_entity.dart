import 'package:equatable/equatable.dart';

class PropertyKpiEntity extends Equatable {
  final num valuationAmount;
  final int totalUnits;
  final int availableUnits;
  final int rentedUnits;
  final int maintenanceUnits;
  final num occupancyRate;

  const PropertyKpiEntity({
    this.valuationAmount = 0,
    this.totalUnits = 0,
    this.availableUnits = 0,
    this.rentedUnits = 0,
    this.maintenanceUnits = 0,
    this.occupancyRate = 0,
  });

  @override
  List<Object?> get props => [
        valuationAmount,
        totalUnits,
        availableUnits,
        rentedUnits,
        maintenanceUnits,
        occupancyRate,
      ];
}
