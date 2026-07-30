import 'package:equatable/equatable.dart';
import 'revenue_entry_entity.dart';

class RevenueReportEntity extends Equatable {
  final RevenueSummaryEntity summary;
  final List<RevenueEntryEntity> chart;
  final RevenueFilterOptionsEntity filterOptions;

  const RevenueReportEntity({
    required this.summary,
    required this.chart,
    required this.filterOptions,
  });

  @override
  List<Object?> get props => [summary, chart, filterOptions];
}

class RevenueSummaryEntity extends Equatable {
  final double totalExpected;
  final double totalCollected;
  final double totalRemaining;
  final double collectionRate;

  const RevenueSummaryEntity({
    required this.totalExpected,
    required this.totalCollected,
    required this.totalRemaining,
    required this.collectionRate,
  });

  @override
  List<Object?> get props => [
    totalExpected,
    totalCollected,
    totalRemaining,
    collectionRate,
  ];
}

class RevenueFilterOptionsEntity extends Equatable {
  final List<PropertyFilterItemEntity> properties;

  const RevenueFilterOptionsEntity({required this.properties});

  @override
  List<Object?> get props => [properties];
}

class PropertyFilterItemEntity extends Equatable {
  final int id;
  final String? name;
  final String code;

  const PropertyFilterItemEntity({
    required this.id,
    this.name,
    required this.code,
  });

  String get displayName =>
      name != null && name!.trim().isNotEmpty ? name! : code;

  @override
  List<Object?> get props => [id, name, code];
}
