import '../../domain/entities/property_kpi_entity.dart';

class PropertyKpiModel extends PropertyKpiEntity {
  const PropertyKpiModel({
    super.valuationAmount = 0,
    super.totalUnits = 0,
    super.availableUnits = 0,
    super.rentedUnits = 0,
    super.maintenanceUnits = 0,
    super.occupancyRate = 0,
  });

  factory PropertyKpiModel.fromJson(Map<String, dynamic> json) {
    return PropertyKpiModel(
      valuationAmount: json['valuation_amount'] as num? ?? 0,
      totalUnits: json['total_units'] as int? ?? 0,
      availableUnits: json['available_units'] as int? ?? 0,
      rentedUnits: json['rented_units'] as int? ?? 0,
      maintenanceUnits: json['maintenance_units'] as int? ?? 0,
      occupancyRate: json['occupancy_rate'] as num? ?? 0,
    );
  }
}
