import '../../domain/entities/properties_stats_entity.dart';

class PropertiesStatsModel extends PropertiesStatsEntity {
  const PropertiesStatsModel({
    required super.totalProperties,
    required super.landsCount,
    required super.buildingsCount,
    required super.residentialCount,
    required super.commercialCount,
    required super.mixedCount,
    required super.totalUnits,
    required super.totalDeeds,
  });

  factory PropertiesStatsModel.fromJson(Map<String, dynamic> json) {
    return PropertiesStatsModel(
      totalProperties: json['total_properties'] as int? ?? 0,
      landsCount: json['lands_count'] as int? ?? 0,
      buildingsCount: json['buildings_count'] as int? ?? 0,
      residentialCount: json['residential_count'] as int? ?? 0,
      commercialCount: json['commercial_count'] as int? ?? 0,
      mixedCount: json['mixed_count'] as int? ?? 0,
      totalUnits: json['total_units'] as int? ?? 0,
      totalDeeds: json['total_deeds'] as int? ?? 0,
    );
  }
}
