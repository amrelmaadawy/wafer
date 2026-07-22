import 'package:equatable/equatable.dart';

class PropertiesStatsEntity extends Equatable {
  final int totalProperties;
  final int landsCount;
  final int buildingsCount;
  final int residentialCount;
  final int commercialCount;
  final int mixedCount;
  final int totalUnits;
  final int totalDeeds;

  const PropertiesStatsEntity({
    required this.totalProperties,
    required this.landsCount,
    required this.buildingsCount,
    required this.residentialCount,
    required this.commercialCount,
    required this.mixedCount,
    required this.totalUnits,
    required this.totalDeeds,
  });

  @override
  List<Object?> get props => [
        totalProperties,
        landsCount,
        buildingsCount,
        residentialCount,
        commercialCount,
        mixedCount,
        totalUnits,
        totalDeeds,
      ];
}
