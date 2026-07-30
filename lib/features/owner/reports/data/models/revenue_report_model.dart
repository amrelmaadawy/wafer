import '../../domain/entities/revenue_report_entity.dart';
import 'revenue_entry_model.dart';

class RevenueReportModel extends RevenueReportEntity {
  const RevenueReportModel({
    required RevenueSummaryModel summary,
    required List<RevenueEntryModel> chart,
    required RevenueFilterOptionsModel filterOptions,
  }) : super(summary: summary, chart: chart, filterOptions: filterOptions);

  factory RevenueReportModel.fromJson(Map<String, dynamic> json) {
    return RevenueReportModel(
      summary: json['summary'] != null
          ? RevenueSummaryModel.fromJson(json['summary'])
          : const RevenueSummaryModel.empty(),
      chart:
          (json['chart'] as List<dynamic>?)
              ?.map((e) => RevenueEntryModel.fromJson(e))
              .toList() ??
          [],
      filterOptions: json['filter_options'] != null
          ? RevenueFilterOptionsModel.fromJson(json['filter_options'])
          : const RevenueFilterOptionsModel(properties: []),
    );
  }
}

class RevenueSummaryModel extends RevenueSummaryEntity {
  const RevenueSummaryModel({
    required super.totalExpected,
    required super.totalCollected,
    required super.totalRemaining,
    required super.collectionRate,
  });

  const RevenueSummaryModel.empty()
    : super(
        totalExpected: 0.0,
        totalCollected: 0.0,
        totalRemaining: 0.0,
        collectionRate: 0.0,
      );

  factory RevenueSummaryModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse('$val') ?? 0.0;
    }

    return RevenueSummaryModel(
      totalExpected: parseDouble(json['total_expected']),
      totalCollected: parseDouble(json['total_collected']),
      totalRemaining: parseDouble(json['total_remaining']),
      collectionRate: parseDouble(json['collection_rate']),
    );
  }
}

class RevenueFilterOptionsModel extends RevenueFilterOptionsEntity {
  const RevenueFilterOptionsModel({
    required List<PropertyFilterItemModel> properties,
  }) : super(properties: properties);

  factory RevenueFilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return RevenueFilterOptionsModel(
      properties:
          (json['properties'] as List<dynamic>?)
              ?.map((e) => PropertyFilterItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PropertyFilterItemModel extends PropertyFilterItemEntity {
  const PropertyFilterItemModel({
    required super.id,
    super.name,
    required super.code,
  });

  factory PropertyFilterItemModel.fromJson(Map<String, dynamic> json) {
    return PropertyFilterItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      code: json['code'] as String? ?? '',
    );
  }
}
