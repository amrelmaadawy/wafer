import '../../domain/entities/statement_period_entity.dart';

class StatementPeriodModel extends StatementPeriodEntity {
  const StatementPeriodModel({
    required super.startDate,
    required super.endDate,
    required super.transactionType,
  });

  factory StatementPeriodModel.fromJson(Map<String, dynamic> json) {
    return StatementPeriodModel(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      transactionType: json['transaction_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'transaction_type': transactionType,
    };
  }
}
