import '../../domain/entities/revenue_entry_entity.dart';

class RevenueEntryModel extends RevenueEntryEntity {
  const RevenueEntryModel({
    required super.month,
    required super.expected,
    required super.collected,
    required super.remaining,
    required super.collectionRate,
  });

  factory RevenueEntryModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse('$val') ?? 0.0;
    }

    return RevenueEntryModel(
      month: json['month'] as String? ?? '',
      expected: parseDouble(json['expected']),
      collected: parseDouble(json['collected']),
      remaining: parseDouble(json['remaining']),
      collectionRate: parseDouble(json['collection_rate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'expected': expected.toStringAsFixed(2),
      'collected': collected.toStringAsFixed(2),
      'remaining': remaining.toStringAsFixed(2),
      'collection_rate': collectionRate.toStringAsFixed(2),
    };
  }
}
