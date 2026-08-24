import '../../domain/entities/statement_summary_entity.dart';

class StatementSummaryModel extends StatementSummaryEntity {
  const StatementSummaryModel({
    required super.openingBalance,
    required super.totalDebit,
    required super.totalCredit,
    required super.currentBalance,
  });

  factory StatementSummaryModel.fromJson(Map<String, dynamic> json) {
    return StatementSummaryModel(
      openingBalance: json['opening_balance'] ?? 0,
      totalDebit: json['total_debit'] ?? 0,
      totalCredit: json['total_credit'] ?? 0,
      currentBalance: json['current_balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opening_balance': openingBalance,
      'total_debit': totalDebit,
      'total_credit': totalCredit,
      'current_balance': currentBalance,
    };
  }
}
