import '../../domain/entities/occupancy_property_entity.dart';

class OccupancyPropertyModel extends OccupancyPropertyEntity {
  const OccupancyPropertyModel({
    required super.propertyId,
    required super.propertyName,
    required super.totalUnits,
    required super.rentedUnits,
    required super.vacantUnits,
    required super.occupancyRate,
  });

  factory OccupancyPropertyModel.fromJson(Map<String, dynamic> json) {
    return OccupancyPropertyModel(
      propertyId: _parseInt(json['property_id']),
      propertyName: json['property_name']?.toString() ?? '',
      totalUnits: _parseInt(json['total_units']),
      rentedUnits: _parseInt(json['rented_units']),
      vacantUnits: _parseInt(json['vacant_units']),
      occupancyRate: _parseDouble(json['occupancy_rate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'property_name': propertyName,
      'total_units': totalUnits,
      'rented_units': rentedUnits,
      'vacant_units': vacantUnits,
      'occupancy_rate': occupancyRate,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
