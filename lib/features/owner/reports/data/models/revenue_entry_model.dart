import '../../domain/entities/revenue_entry_entity.dart';

class RevenueEntryModel extends RevenueEntryEntity {
  const RevenueEntryModel({
    required super.month,
    required super.expected,
    required super.collected,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'expected': expected.toStringAsFixed(2),
      'collected': collected.toStringAsFixed(2),
    };
  }
}
