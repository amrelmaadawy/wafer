import '../../domain/entities/property_summary_entity.dart';

class PropertySummaryModel extends PropertySummaryEntity {
  const PropertySummaryModel({
    super.required = 0,
    super.due = 0,
    super.collected = 0,
    super.expenses = 0,
    super.commissions = 0,
    super.payments = 0,
    super.insurances = 0,
    super.balance = 0,
  });

  factory PropertySummaryModel.fromJson(Map<String, dynamic> json) {
    return PropertySummaryModel(
      required: json['required'] as num? ?? 0,
      due: json['due'] as num? ?? 0,
      collected: json['collected'] as num? ?? 0,
      expenses: json['expenses'] as num? ?? 0,
      commissions: json['commissions'] as num? ?? 0,
      payments: json['payments'] as num? ?? 0,
      insurances: json['insurances'] as num? ?? 0,
      balance: json['balance'] as num? ?? 0,
    );
  }
}
